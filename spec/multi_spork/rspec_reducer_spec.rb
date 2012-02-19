require 'spec_helper'

describe MultiSpork::RSpecReducer do
  describe "reduce" do
    let(:output1) { "\n7 examples, 4 failures\n\n\n" }
    let(:output2) { "\n8 examples, 5 failures, 2 pending\n\n" }
    let(:output3) { "\n9 examples, 6 failures, 3 pending\n" }

    it "cramps results into 1 single summary" do
      MultiSpork::RSpecReducer.new.summarize([output1, output2, output3]).should == "24 examples, 15 failures, 5 pendings"
    end
  end
end
