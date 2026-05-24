class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  # rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ApiError, with: :handle_api_error

  before_action :authenticate!
  before_action -> { check_permissions!("read") }

  private

  def authenticate!
    api_key = request.headers["X-API-KEY"]

    raise ForbiddenError unless api_key

    @key = ApiKey.find_by(key: api_key)

    raise ForbiddenError unless @key
  end

  def check_permissions!(required_permission)
    raise ForbiddenError, "Permission denied" unless @key.permissions.include?(required_permission)
  end

  def handle_api_error(exception)
    render_error(
      code: exception.code,
      message: exception.message,
      status: exception.status
    )
  end

  # def handle_record_not_found(exception)
  #   render_error(
  #     code: "RECORD_NOT_FOUND",
  #     message: exception.message,
  #     status: :not_found
  #   )
  # end

  def handle_record_invalid(exception)
    render_error(
      code: "VALIDATION_ERROR",
      message: "Validation failed",
      status: :unprocessable_entity,
      details: exception.record.errors.to_hash
    )
  end

  def render_success(message, data, status: :ok)
    render json: { message: message, metadata: data }, status: status
  end

  def render_error(code:, message:, status:, details: nil)
    response = {
      error: {
        code: code,
        message: message
      }
    }

    response[:error][:details] = details if details.present?

    render json: response, status: status
  end
end
