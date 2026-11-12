class HealthController < ApplicationController
  skip_before_action :require_private_access, only: %i[live ready]

  def live
    render json: { status: "ok" }
  end

  def ready
    ActiveRecord::Base.connection.execute("SELECT 1")
    render json: { status: "ready" }
  rescue StandardError => error
    Rails.logger.error(
      {
        event: "health_check_failed",
        check: "ready",
        error_class: error.class.name
      }.to_json
    )
    metrics.increment("health_ready_failures_total")
    render json: { status: "not_ready" }, status: :service_unavailable
  end

  private

  def metrics
    Rails.application.config.x.metrics
  end
end
