module MultiSpork
  module TestExecutor
    class << self
      def run_in_parallel base_cmd, test_set, runner_count
        Parallel.map(groups, :in_processes => runner_count) do |group|
          if group.empty?
            {:stdout => '', :exit_status => 0}
          else
            MultiSpork::TestExecutor.run("bundle exec cucumber features/support features/step_definitions", group.map(&:first))
          end
        end
      end

      def run(base_cmd, test_set)
        params = test_set.join(" ")
        MultiSpork::ShellExecutor.execute("#{base_cmd} #{params}")
      end
    end
  end
end
