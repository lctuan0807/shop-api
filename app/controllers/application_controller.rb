class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  # rescue_from ApiError, with: :handle_api_error 

  rescue_from ApiError do |error|
    ErrorNotifier.notify(error)

    handle_api_error(error)
  end

  before_action :identify_api_key!
  before_action -> { check_permissions!("read") }
  before_action :authenticate!

  private

  def current_shop
    @current_shop ||= @token&.shop
  end

  def authenticate!
    @token = AuthenticateService.call(request)
  end

  def identify_api_key!
    api_key = request.headers["X-API-KEY"]

    raise ForbiddenError unless api_key

    @key = ApiKey.find_by(key: api_key)

    raise ForbiddenError unless @key
  end

  def check_permissions!(required_permission)
    raise ForbiddenError, "Permission denied" unless @key.permissions.include?(required_permission)
  end

  def serialize_collection(resources, serializer:)
    ActiveModelSerializers::SerializableResource.new(
      resources,
      each_serializer: serializer
    )
  end

  def handle_api_error(exception)
    render_error(
      code: exception.code,
      message: exception.message,
      status: exception.status
    )
  end

  def handle_record_invalid(exception)
    render_error(
      code: "VALIDATION_ERROR",
      message: "Validation failed",
      status: :unprocessable_entity,
      details: exception.record.errors.to_hash
    )
  end

  def handle_record_not_found(exception)
    render_error(
      code: "NOT_FOUND",
      message: "Record not found",
      status: :not_found
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
