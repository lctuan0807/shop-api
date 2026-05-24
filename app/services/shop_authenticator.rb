class ShopAuthenticator
  def initialize(params)
    @params = params
  end

  def call
    shop = Shop.find_by(email: @params[:email])

    raise BadRequestError, "Shop not registered" unless shop

    if shop&.authenticate(@params[:password])
      public_key, private_key = SecureRandom.hex(64), SecureRandom.hex(64)

      tokens = TokenService.issue_token({
        user_id: shop.id,
        email: shop.email
      }, public_key: public_key, private_key: private_key)

      TokenService.create_token(
        shop.id,
        public_key: public_key,
        private_key: private_key,
        refresh_token: tokens[:refresh_token]
      )

      [ shop, tokens ]
    else
      raise UnauthorizedError, "Invalid credentials"
    end
  end
end
