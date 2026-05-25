class JsonWebToken
  def self.encode(payload, key, expires_in = 24.hours.from_now)
    payload[:exp] = expires_in.to_i

    JWT.encode(payload, key)
  end

  def self.decode(token, key)
    payload = JWT.decode(token, key)[0]
    HashWithIndifferentAccess.new payload
  rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
    raise InvalidTokenError, "Invalid or expired token"
  end
end
