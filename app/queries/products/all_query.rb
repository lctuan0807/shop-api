module Products
  class AllQuery
    def initialize(scope = Product.all)
      @scope = scope
    end

    def call(params, limit = 50)
      @params = params
      puts "skip: #{skip}, limit: #{limit}"

      products = @scope.published
      products = products.order(sort_by).limit(limit).offset(skip * limit)
      products
    end

    private

    def sort_by
      @params[:sort] == "ctime" ? { id: :desc } : { id: :asc }
    end

    def skip
      (@params[:page] || 1) - 1
    end
  end
end
