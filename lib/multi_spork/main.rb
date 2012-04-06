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
    attr_accessor :reducer

    def initialize(attrs)
      attrs.each do |attr, value|
        send(:"#{attr}=", value)
      end

      self.paths = []
      self.worker_pool = MultiSpork.config.worker_pool
      self.worker = nil
    end


    def get_parser
      @parser ||= OptionParser.new do |p|
        p.summary_width = 28
        p.banner = banner
        yield p
      end
    end

    def run
      if parse_options
        if worker > 0
          if paths.length > 0
            start = Time.now
            success, outputs = MultiSpork::TestExecutor.run_in_parallel(
              test_cmd,
              MultiSpork::TestResolver.resolve(paths, test_surfix),
              worker
            )
            puts "Test run finished in #{Time.now - start} seconds"
            puts "SUMMARY: " + reducer.summarize(outputs) if reducer
            exit success
          else
            warn "No features found in the given options"
            exit 1
          end
        else
          warn "Worker set to 0. Won't run test"
          exit 2
        end
      else
        puts get_parser
        exit 1
      end
    end

    def parse_options
      successful = true

      get_parser do |parser|
        parser.on("-w COUNT", "--worker=COUNT", "Set number of worker to COUNT. Default to value set by ./config/multi_spork or number of system processors") do |count|
          self.worker = count.to_i
        end

        parser.on("-r PATH", "--require=PATH", "Require a file.") do |path|
          require path
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
      end

      if worker.nil?
        puts "Worker is not provided. Use worker_pool (#{worker_pool})"
        self.worker = worker_pool
      end

      successful
    end
  end
end
