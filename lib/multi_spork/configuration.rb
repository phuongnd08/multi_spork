module MultiSpork
  class Configuration
    def worker_pool
      @worker_pool || Parallel.processor_count
    end

    def worker_pool=(size)
      @worker_pool = size
    end
  end
end
