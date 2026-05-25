class AuthenticateService
  attr_reader :request

  def self.call(request)
    new(request).call
  end

  def initialize(request)
    @request = request
  end

  def call
    user_id = client_id
    token = find_token!(user_id)

    decoded_payload = decode_access_token!(token)

    validate_user!(user_id, decoded_payload)

    token
  end

  private

  def client_id
    @request.headers["X-CLIENT-ID"].presence || raise(UnauthorizedError, "Missing client id")
  end

  def bearer_token
    @request.headers["Authorization"]&.split(" ")&.last || raise(UnauthorizedError, "Missing access token")
  end

  def find_token!(user_id)
    Token.find_by(user_id: user_id) || raise(NotFoundError, "Token not found")
  end

  def decode_access_token!(token)
    JWT.decode(
      bearer_token,
      token.public_key,
    ).first
  rescue JWT::DecodeError,
        JWT::ExpiredSignature,
        JWT::VerificationError
    raise UnauthorizedError, "Invalid token"
  end

  def validate_user!(user_id, decoded_payload)
    decoded_user_id = decoded_payload["user_id"]

    return if user_id.to_s == decoded_user_id.to_s

    raise UnauthorizedError, "Invalid request"
  end
end
