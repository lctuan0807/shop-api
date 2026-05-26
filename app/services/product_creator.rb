class ProductCreator
  def self.call(product_params)
    Product.create(product_params)
  end
end
