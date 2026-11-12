require "test_helper"

class ApplicationMetricsTest < ActiveSupport::TestCase
  setup do
    @metrics = ApplicationMetrics.new
  end

  test "stores counters and timing observations" do
    @metrics.increment("requests_total")
    @metrics.increment("requests_total")
    @metrics.observe("request_duration_ms", 12.5)

    assert_equal 2, @metrics.snapshot.dig("counters", "requests_total")
    assert_equal 1, @metrics.snapshot.dig("timings", "request_duration_ms", "count")
    assert_equal 12.5, @metrics.snapshot.dig("timings", "request_duration_ms", "total_ms")
  end

  test "can reset collected data" do
    @metrics.increment("requests_total")

    @metrics.reset!

    assert_empty @metrics.snapshot.fetch("counters")
    assert_empty @metrics.snapshot.fetch("timings")
  end
end
