class ShopCreator
  def initialize(params)
    @params = params
  end

  def call
    raise ShopAlreadyExists if Shop.exists?(email: @params[:email])

    new_shop = Shop.new(@params)

    if new_shop.save!
      public_key, private_key = SecureRandom.hex(64), SecureRandom.hex(64)

      Token.create!(
        public_key: public_key,
        private_key: private_key,
        user_id: new_shop.id
      )

      tokens = TokenCreator.issue_token({
        user_id: new_shop.id,
        email: new_shop.email
      }, public_key: public_key, private_key: private_key)

    end

    [ new_shop, tokens ]
  end
end
