class ApplicationMetrics
  def initialize
    @counters = Hash.new(0)
    @timings = {}
    @mutex = Mutex.new
  end

  def increment(name)
    @mutex.synchronize { @counters[name] += 1 }
  end

  def observe(name, value)
    @mutex.synchronize do
      timing = (@timings[name] ||= { "count" => 0, "total_ms" => 0.0 })
      timing["count"] += 1
      timing["total_ms"] += value.to_f
    end
  end

  def snapshot
    @mutex.synchronize do
      {
        "counters" => @counters.dup,
        "timings" => @timings.transform_values(&:dup)
      }
    end
  end

  def reset!
    @mutex.synchronize do
      @counters.clear
      @timings.clear
    end
  end
end
