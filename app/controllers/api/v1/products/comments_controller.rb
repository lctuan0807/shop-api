module Api
  module V1
    module Products
      class CommentsController < ApplicationController
        def index
          comments = product.comments.roots.order(created_at: :desc)

          render_success(
            "Comments retrieved successfully",
            {
              comments: comments.map do |comment|
                Comments::TreeSerializer.call(comment)
              end
            }
          )
        end

        def create
          comment = Comments::CreateService.new(product, comment_params).call

          render_success(
            "Comment created successfully",
            {
              comment: CommentSerializer.new(comment)
            }
          )
        end

        def destroy
          comment = Comments::DeleteService.new(comment, params[:user_id]).call

          render_success(
            "Comment deleted successfully",
            {
              comment: CommentSerializer.new(comment)
            }
          )
        end

        private

        def product
          @product ||= Product.find(params[:product_id])
        end

        def comment
          @comment ||= Comment.find(params[:id])
        end

        def comment_params
          params.permit(:content, :user_id, :parent_id)
        end
      end
    end
  end
end
