module Products
  class SearchQuery
    def initialize(scope = Product.all)
      @scope = scope
    end

    def call(params)
      products = @scope
      products = products.published
      # ILIKE is case-insensitive, but it's not supported by pg_search
      # products = search(products, params[:q])
      
      products = products.search(params[:q]) # pg_search 
      products
    end

    private

    def search(products, keyword)
      return products if keyword.blank?

      products.where(
        "name ILIKE :keyword
         OR description ILIKE :keyword",
        keyword: "%#{keyword}%"
      )
    end
  end
end
