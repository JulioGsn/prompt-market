class MetricsController < ApplicationController
  def show
    render json: Rails.application.config.x.metrics.snapshot
  end
end
