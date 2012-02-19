require 'rubygems'
require 'parallel'
require 'optparse'

module MultiSpork
  class Main
    attr_accessor :paths
    attr_accessor :worker_pool
    attr_accessor :worker
    attr_accessor :test_cmd
    attr_accessor :test_surfix
    attr_accessor :banner

    def initialize(test_cmd, test_surfix, banner)
      self.test_cmd = test_cmd
      self.test_surfix = test_surfix
      self.paths = []
      self.worker_pool = MultiSpork.config.worker_pool
      self.worker = nil
    end


    def parser
      @parser ||= OptionParser.new do |p|
        p.summary_width = 28
        p.banner = banner
      end
    end

    def run
      if parse_options
        if worker > 0
          if paths.length > 0
            start = Time.now
            MultiSpork::TestExecutor.run_in_parallel(
              test_cmd,
              MultiSpork::TestResolver.resolve(paths, test_surfix),
              worker
            )
            puts "Test run finished in #{Time.now - start} seconds"
          else
            warn "No features found in the given options"
            exit 1
          end
        else
          warn "Worker set to 0. Won't run test"
          exit 2
        end
      else
        puts parser
        exit 1
      end
    end

    def parse_options
      successful = true

      parser.on("-w COUNT", "--worker=COUNT", "Set number of worker to COUNT. Default to value set by ./config/multi_spork or number of system processors") do |count|
        self.worker = count.to_i
      end

      if worker.nil?
        puts "Worker is not provided. Use worker_pool (#{worker_pool})"
        self.worker = worker_pool
      end

      parser.on_tail("-h", "--help", "Shows this help message") do
        successful = false
      end

      if ARGV.empty?
        successful = false
      else
        parser.order(ARGV) do |path|
          paths << path
        end
      end

      successful
    end
  end
end
