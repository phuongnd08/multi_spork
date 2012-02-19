module MultiSpork
  module TestExecutor
    class << self
      def run_in_parallel base_cmd, test_set, runner_count
        index = 0
        test_groups = test_set.group_by { |_| (index += 1) % runner_count }
        run_sets base_cmd, test_groups, runner_count
      end

      def run_sets(base_cmd, groups, processes_count)
        Parallel.map(groups.keys, :in_processes => processes_count) do |index|
          if groups[index].empty?
            {:stdout => '', :exit_status => 0}
          else
            MultiSpork::TestExecutor.run(base_cmd, groups[index])
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
