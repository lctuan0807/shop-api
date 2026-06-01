module Products
  class BaseCreator
    def create(params)
      product = Product.create!(common_attributes(params))
      create_inventory(product, params)
      product
    end

    private

    def common_attributes(params)
      {
        name: params[:name],
        description: params[:description],
        thumbnail: params[:thumbnail],
        quantity: params[:quantity],
        price: params[:price],
        category: params[:category],
        shop_id: params[:shop_id]
      }
    end

    def validate_metadata!(metadata)
      missing = required_fields.select do |field|
        metadata[field].blank?
      end

      return if missing.empty?

      raise BadRequestError,
            "Missing fields: #{missing.join(', ')}"
    end

    def required_fields
      raise NotImplementedError, "Subclasses must implement #required_fields"
    end

    def create_inventory(product)
      Inventory.create!(
        product: product,
        shop: product.shop,
        stock: product.quantity,
        reservations: []
      )
    end
  end
end
