require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "live health check returns ok" do
    get "/health/live"

    assert_response :success
    assert_equal({ "status" => "ok" }, JSON.parse(response.body))
  end

  test "ready health check verifies the database" do
    get "/health/ready"

    assert_response :success
    assert_equal({ "status" => "ready" }, JSON.parse(response.body))
  end

  test "metrics endpoint returns collected metrics" do
    get "/metrics"

    assert_response :success
    metrics = JSON.parse(response.body)
    assert_kind_of Hash, metrics.fetch("counters")
    assert_kind_of Hash, metrics.fetch("timings")
  end

  test "ready health check returns unavailable when the database fails" do
    failing_connection = Object.new
    failing_connection.define_singleton_method(:execute) do |_query|
      raise StandardError, "database unavailable"
    end

    original_connection = ActiveRecord::Base.method(:connection)
    ActiveRecord::Base.define_singleton_method(:connection) { failing_connection }

    begin
      get "/health/ready"
    ensure
      ActiveRecord::Base.define_singleton_method(:connection, original_connection)
    end

    assert_response :service_unavailable
    assert_equal({ "status" => "not_ready" }, JSON.parse(response.body))
  end
end
