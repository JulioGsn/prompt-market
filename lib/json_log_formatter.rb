require "json"
require "time"

class JsonLogFormatter < Logger::Formatter
  def call(severity, time, _progname, message)
    payload = {
      "timestamp" => time.utc.iso8601(3),
      "severity" => severity
    }

    payload.merge!(structured_message(message))
    "#{JSON.generate(payload)}\n"
  end

  private

  def structured_message(message)
    parsed = JSON.parse(message.to_s)
    parsed.is_a?(Hash) ? parsed : { "message" => message.to_s }
  rescue JSON::ParserError
    { "message" => message.to_s }
  end
end
