class ShopCreator
  def initialize(params)
    @params = params
  end

  def call
    raise BadRequestError, "Shop already exists" if Shop.exists?(email: @params[:email])

    new_shop = Shop.new(@params)

    if new_shop.save!
      public_key, private_key = SecureRandom.hex(64), SecureRandom.hex(64)

      tokens = TokenService.issue_token({
        user_id: new_shop.id,
        email: new_shop.email
      }, public_key: public_key, private_key: private_key)

      TokenService.create_or_update_token(
        new_shop.id,
        public_key: public_key,
        private_key: private_key,
        refresh_token: tokens[:refresh_token]
      )
    end

    [ new_shop, tokens ]
  end
end
