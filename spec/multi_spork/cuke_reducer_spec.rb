require 'spec_helper'

describe MultiSpork::CukeReducer do
  describe "reduce" do
    let(:output1) { "\n2 scenarios (1 passed, 1 failures)\n3 steps (3 passed)" }

    let(:output2) { "\n2 scenarios (1 pending, 1 passed)\n4 steps (4 skipped)\n\n" }

    let(:output3) { "\n3 scenarios (3 pending)\n" }

    it "cramps results into 1 single summary" do
      MultiSpork::CukeReducer.new.summarize([output1, output2, output3]).
        should == "7 scenarios (2 passed, 1 failure, 4 pending)\n7 steps (3 passed, 4 skipped)"
    end
  end
end
