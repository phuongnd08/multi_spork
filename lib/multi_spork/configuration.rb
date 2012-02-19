module MultiSpork
  class Configuration
    def runner_count
      @runner_count || Parallel.processor_count
    end

    def runner_count=(count)
      @runner_count = count
    end
  end
end
