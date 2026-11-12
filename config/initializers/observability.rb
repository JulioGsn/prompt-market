require Rails.root.join("lib/json_log_formatter").to_s

Rails.application.config.to_prepare do
  Rails.application.config.x.metrics = ApplicationMetrics.new
end

ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  payload = event.payload
  metrics = Rails.application.config.x.metrics
  status = payload[:status].to_i

  metrics.increment("http_requests_total")
  metrics.increment("http_5xx_total") if status >= 500
  metrics.observe("http_request_duration_ms", event.duration)

  Rails.logger.info(
    {
      event: "http_request",
      method: payload[:method],
      path: payload[:path],
      status: status,
      duration_ms: event.duration.round(2),
      controller: payload[:controller],
      action: payload[:action],
      request_id: payload[:request]&.request_id
    }.to_json
  )
end
