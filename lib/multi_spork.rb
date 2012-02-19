require "spork"
require 'parallel'

module MultiSpork
  autoload :TestExecutor, "multi_spork/test_executor"
  autoload :TestResolver, "multi_spork/test_resolver"
  autoload :ShellExecutor, "multi_spork/shell_executor"
  autoload :Configuration, "multi_spork/configuration"

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
        if defined?(ActiveRecord::Base) && defined?(Rails)
          db_count = MultiSpork.config.worker_pool
          db_index = (Spork.run_count % db_count) + 1
          config = YAML.load(ERB.new(Rails.root.join('config/database.yml').read).result)['test']
          config["database"] += db_index.to_s
          ActiveRecord::Base.establish_connection(config)
        end
        yield
      end
    end

    def config
      @config || Configuration.new
    end

    def configure
      yield config
    end
  end
end
