module Comments
  class CreateService
    def initialize(product, params)
      @product = product
      @params = params
    end

    def call
      if params[:parent_id]
        create_reply
      else
        create_root
      end
    end

    private

    attr_reader :product, :params

    def create_root
      product.comments.create!(
        content: params[:content],
        user_id: params[:user_id]
      )
    end

    def create_reply
      parent = product.comments.find(params[:parent_id])

      parent.children.create!(content: params[:content], user_id: params[:user_id], product: product)
    end
  end
end
