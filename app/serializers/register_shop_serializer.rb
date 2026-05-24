# register_shop_serializer.rb
class RegisterShopSerializer < ActiveModel::Serializer
  attributes :shop, :tokens

  def shop
    ShopSerializer.new(object)
  end

  def tokens
    instance_options[:tokens]
  end
end
