# add rake tasks if we are inside Rails
if defined?(Rails::Railtie)
  module MultiSpork
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load File.expand_path("../../tasks/multi_spork.rake", __FILE__)
      end
    end
  end
end
