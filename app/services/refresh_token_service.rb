class RefreshTokenService
  def initialize(user_id:, refresh_token:)
    @user_id = user_id
    @refresh_token = refresh_token
  end

  def call
    token = find_token!
    verify_refresh_token!(token)
    detect_token_reuse!(token)

    decoded = decode_refresh_token!(token)
    validate_user!(decoded)

    rotate_tokens(token)
  end

  private

  def find_token!
    Token.find_by(user_id: @user_id) || raise(NotFoundError, "Token not found")
  end

  def verify_refresh_token!(token)
    return if token.refresh_token == @refresh_token

    detect_token_reuse!(token)
    raise UnauthorizedError, "Invalid refresh token"
  end

  def detect_token_reuse!(token)
    return unless token.refresh_token_used.include?(@refresh_token)

    token.destroy!
    raise UnauthorizedError, "Token reuse detected. All tokens have been revoked."
  end

  def decode_refresh_token!(token)
    JWT.decode(@refresh_token, token.private_key).first
  rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
    raise UnauthorizedError, "Invalid or expired refresh token"
  end

  def validate_user!(decoded)
    return if @user_id.to_s == decoded["user_id"].to_s

    raise UnauthorizedError, "Invalid request"
  end

  def rotate_tokens(token)
    public_key, private_key = SecureRandom.hex(64), SecureRandom.hex(64)

    new_tokens = TokenService.issue_token(
      { user_id: @user_id, email: token.shop.email },
      public_key: public_key,
      private_key: private_key
    )

    token.update!(
      public_key: public_key,
      private_key: private_key,
      refresh_token: new_tokens[:refresh_token],
      refresh_token_used: token.refresh_token_used + [ @refresh_token ]
    )

    new_tokens
  end
end
