module Comments
  class DeleteService
    def initialize(comment, user_id)
      @comment = comment
      @user_id = user_id
    end

    def call
      authorize!

      comment.destroy!
    end

    private

    attr_reader :comment,
                :user_id

    def authorize!
      return if comment.user_id == user_id

      raise ForbiddenError, "Not allowed"
    end
  end
end
