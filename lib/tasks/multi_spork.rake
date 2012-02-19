require 'active_record'
require 'multi_spork'

namespace :multi_spork do
  namespace :testdbs do
    desc "Clone schema of development db to test dbs to be used by multi_spork worker"
    task :clone => "db:load_config" do
      org_test_configuration = ActiveRecord::Base.configurations['test']

      Rake::Task["db:schema:dump"].invoke

      MultiSpork.config.worker_pool.times do |index|
        test_configuration = org_test_configuration.clone
        test_configuration["database"] += (index+1).to_s
        ActiveRecord::Base.configurations['test'] = test_configuration
        ["db:test:purge", "db:test:load_schema", "db:schema:load"].each do |task_name|
          Rake::Task[task_name].reenable
        end

        Rake::Task["db:test:load_schema"].invoke
      end

      ActiveRecord::Base.configurations['test'] = org_test_configuration
    end
  end
end
