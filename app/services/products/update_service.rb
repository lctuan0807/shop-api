module Products
  class UpdateService
    def initialize(product, params)
      @product = product
      @params = params
    end

    def call
      @product.update!(merged_attributes)
    end

    private

    def merged_attributes
      attributes = @params.except(:metadata)

      if @params[:metadata].present?
        attributes[:metadata] = @product.metadata.merge(@params[:metadata])
      end

      if @params[:variations].present?
        attributes[:variations] = @product.variations.merge(@params[:variations])
      end

      attributes
    end
  end
end
