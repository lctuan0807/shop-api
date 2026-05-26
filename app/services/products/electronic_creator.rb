module Products
  class ElectronicCreator < BaseCreator
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
      %w[manufacturer model color]
    end
  end
end
