module Api
  module V1
    class SearchController < ApplicationController
      skip_before_action :authenticate!, only: [ :index ]

      def index
        products = Products::SearchQuery.new.call(params)

        render_success(
          "Products retrieved successfully",
          {
            products: serialize_collection(products, serializer: ProductSerializer)
          }
        )
      end
    end
  end
end
