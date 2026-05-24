class TokenCreator
  ACCESS_TOKEN_EXPIRY = 2.days
  REFERESH_TOKEN_EXPIRY = 7.days

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
