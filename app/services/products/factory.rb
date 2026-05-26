module Products
  class Factory
    PRODUCT_CREATORS = {
        "clothing" => ClothingCreator,
        "electronic" => ElectronicCreator
    }

    def self.build(category)
      creator = PRODUCT_CREATORS[category]

      raise BadRequestError, "Unsupported product category: #{category}" unless creator

      creator.new
    end
  end
end
