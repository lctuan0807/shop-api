class JsonWebToken
  def self.encode(payload, key, expires_in = 24.hours.from_now)
    payload[:exp] = expires_in.to_i

    JWT.encode(payload, key)
  end

  # def self.decode(token)
  #   payload = JWT.decode(token, SECRET_KEY)[0]
  #   HashWithIndifferentAccess.new payload
  # rescue JWT::DecodeError
  #   raise InvalidTokenError
  # end
end
