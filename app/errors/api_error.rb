class ApiError < StandardError
  attr_reader :code, :status

  def initialize(message, code:, status:)
    @code = code
    @status = status

    super(message)
  end
end
