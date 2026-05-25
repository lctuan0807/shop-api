class RefreshTokenService
  attr_accessor :token

  def initialize(user_id:, refresh_token:)
    @user_id = user_id
    @refresh_token = refresh_token
  end

  def call
    @token = find_token!
    verify_token!
    detect_token_reuse!
    decode_refresh_token!
    validate_user!
    rotate_token!

    new_tokens
  end

  private

  def find_token!
    Token.find_by(user_id: @user_id) || raise(NotFoundError, "Token not found")
  end

  def verify_token!
    unless token.refresh_token == @refresh_token
      raise UnauthorizedError, "Invalid refresh token"
    end
  end

  def detect_token_reuse!
    if Array(token.refresh_tokens_used).include?(@refresh_token)
      token.destroy!
      raise UnauthorizedError, "Token reuse detected. Token has been revoked. Please try login again"
    end
  end

  def decode_refresh_token!
    @decoded ||= JsonWebToken.decode(@refresh_token, token.private_key)
  end

  def validate_user!
    unless @user_id.to_s == @decoded["user_id"].to_s
      raise UnauthorizedError, "Shop not registered"
    end
  end

  def new_tokens
    @new_tokens ||= TokenService.issue_token({
      user_id: @user_id,
      email: token.shop.email
    }, public_key: token.public_key, private_key: token.private_key)
  end 

  def rotate_token!
    token.update!(
      refresh_token: new_tokens[:refresh_token],
      refresh_tokens_used: token.refresh_tokens_used + [ @refresh_token ]
    )
  end
end
