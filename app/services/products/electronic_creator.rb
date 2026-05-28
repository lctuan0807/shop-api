module Products
  class ElectronicCreator < BaseCreator
    def create(params)
      validate_metadata!(params[:metadata])

      Product.create!(
        common_attributes(params).merge(
          metadata: {
            manufacturer: params.dig(:metadata, :manufacturer),
            model: params.dig(:metadata, :model),
            color: params.dig(:metadata, :color)
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
