module Products
  class ClothingCreator < BaseCreator
    def create(params)
      validate_metadata!(params[:metadata])

      Product.create!(
        common_attributes(params).merge(
          metadata: {
            brand: params.dig(:metadata, :brand),
            size: params.dig(:metadata, :size),
            material: params.dig(:metadata, :material)
          }
        )
      )
    end

    private

    def required_fields
      %w[brand size material]
    end
  end
end
