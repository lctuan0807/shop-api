class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  before_action :authenticate!
  before_action -> { check_permissions!("read") }

  private

  def authenticate!
    api_key = request.headers["X-API-KEY"]

    return forbidden unless api_key

    @key = ApiKey.find_by(key: api_key)

    forbidden unless @key
  end

  def forbidden
    render json: { message: "Forbidden" }, status: :forbidden
  end

  def check_permissions!(required_permission)
    return if @key.permissions.include?(required_permission)

    render json: { message: "Permission denied" }, status: :forbidden
  end

  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors }, status: :unprocessable_entity
  end
end
