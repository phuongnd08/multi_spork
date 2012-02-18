module MultiSpork
  class Configuration
    attr_accessor :runner_count

    def runner_count
      super || Parallel.processor_count
    end
  end
end
