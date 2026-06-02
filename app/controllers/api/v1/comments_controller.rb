module Api
  module V1
    class CommentsController < ApplicationController
      def replies
        render_success(
          "Replies retrieved successfully",
          {
            comment: CommentSerializer.new(comment),
            replies: comment.children.map do |reply|
              Comments::TreeSerializer.call(reply)
            end
          }
        )
      end

      private

      def comment
        @comment ||= Comment.find(params[:id])
      end
    end
  end
end
