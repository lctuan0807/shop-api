module Products
  class BaseCreator
    def create(params)
      Product.create!(common_attributes(params))
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
  end
end
