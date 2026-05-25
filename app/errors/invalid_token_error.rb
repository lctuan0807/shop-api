class InvalidTokenError < ApiError
  def initialize(message = "Invalid token")
    super(
      message,
      code: "INVALID_TOKEN",
      status: :unauthorized
    )
  end
end
