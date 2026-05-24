class ForbiddenError < ApiError
  def initialize(message = "Forbidden")
    super(
      message,
      code: "FORBIDDEN",
      status: :forbidden
    )
  end
end
