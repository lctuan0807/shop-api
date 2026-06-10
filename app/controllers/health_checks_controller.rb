class HealthChecksController < ApplicationController
  def show
    render json: { status: "ok", message: "Service is running", timestamp: Time.current }
  end
end
