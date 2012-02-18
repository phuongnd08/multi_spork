require 'spec_helper'

describe MultiSpork::TestExecutor do
  describe "run" do
    it "invokes Executor.execute on the given set" do
      MultiSpork::ShellExecutor.should_receive(:execute).with("test_cmd f1.feature f2.feature")
      MultiSpork::TestExecutor.run("test_cmd", ["f1.feature", "f2.feature"])
    end
  end
end
