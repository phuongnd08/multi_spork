require 'spec_helper'

describe MultiSpork::TestExecutor do
  def mocked_process
    open('|cat /dev/null')
  end

  describe "run" do
    it "invokes Executor.execute on the given set" do
      MultiSpork::ShellExecutor.should_receive(:execute).with("test_cmd f1.feature f2.feature")
      MultiSpork::TestExecutor.run("test_cmd", ["f1.feature", "f2.feature"])
    end
  end

  describe "run_in_parallel" do
    it "invokes run_sets with the proper argument" do
      MultiSpork::TestExecutor.should_receive(:run_sets) do |base_cmd, groups, processes_count|
        base_cmd.should == "cmd"
        groups.keys.length.should == 3
        groups.each { |set| set.length.should == 2 }
        processes_count.should == 3
        [[true, '1'], [true, '2'], [true, '3']]
      end

      results = MultiSpork::TestExecutor.run_in_parallel "cmd", (1..6).map(&:to_s), 3
      results.should == [true, ['1', '2', '3']]
    end
  end

  describe "run_sets" do
    it "invokes run with proper arguments" do
      MultiSpork::ShellExecutor.should_receive(:open) do
        mocked_process #return different mocked process every time
      end.exactly(2).times
      MultiSpork::TestExecutor.run_sets "cmd", { "1" => ["a", "b"], "2" => ["c", "d"] }, 0
    end
  end
end
