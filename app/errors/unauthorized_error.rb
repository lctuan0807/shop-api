class UnauthorizedError < ApiError
  def initialize(message = "Unauthorized")
    super(
      message,
      code: "UNAUTHORIZED",
      status: :unauthorized
    )
  end
end
