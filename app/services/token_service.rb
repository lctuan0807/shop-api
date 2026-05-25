class TokenService
  ACCESS_TOKEN_EXPIRY = 2.days.from_now
  REFERESH_TOKEN_EXPIRY = 7.days.from_now

  def self.create_or_update_token(user_id, private_key: nil, public_key: nil, refresh_token: nil)
    token = Token.find_or_create_by(user_id: user_id)

    token.update!(
      public_key: public_key,
      private_key: private_key,
      refresh_token_used: [],
      refresh_token: refresh_token
    )
  end

  def self.issue_token(payload, private_key: nil, public_key: nil)
    access_token = JsonWebToken.encode(
      payload,
      public_key,
      ACCESS_TOKEN_EXPIRY
    )

    refresh_token = JsonWebToken.encode(
      payload,
      private_key,
      REFERESH_TOKEN_EXPIRY
    )

    { access_token:, refresh_token: }
  end
end
