require "spork"
require 'parallel'
require 'multi_spork/railtie'

module MultiSpork
  autoload :TestExecutor, "multi_spork/test_executor"
  autoload :TestResolver, "multi_spork/test_resolver"
  autoload :ShellExecutor, "multi_spork/shell_executor"
  autoload :Configuration, "multi_spork/configuration"
  autoload :Main, "multi_spork/main"
  autoload :ResultReducer, "multi_spork/result_reducer"
  autoload :RSpecReducer, "multi_spork/rspec_reducer"

  class << self
    def prefork
      Spork.prefork do
        yield
        if defined? ActiveRecord::Base
          ActiveRecord::Base.connection.disconnect!
        end
      end
    end

    def each_run
      Spork.each_run do
        if defined?(ActiveRecord::Base)
          db_pool = MultiSpork.config.worker_pool
          db_index = (Spork.run_count % db_pool) + 1
          config = ActiveRecord::Base.configurations['test'].clone
          config["database"] += db_index.to_s
          ActiveRecord::Base.establish_connection(config)
        end
        yield
      end
    end

    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end
end

config_path = if defined?(Rails)
                File.expand_path("config/multi_spork", Rails.root)
              else
                File.expand_path("config/multi_spork", Dir.pwd)
              end

begin
  require config_path
rescue LoadError
  puts "File config/multi_spork cannot be found. Assuming worker pool #{MultiSpork.config.worker_pool})"
end
