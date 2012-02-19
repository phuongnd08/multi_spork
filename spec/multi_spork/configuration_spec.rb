require 'spec_helper'

describe MultiSpork::Configuration do
  subject { MultiSpork::Configuration.new }

  it "has default value" do
    subject.runner_count.should >= 1
  end

  it "can be changed" do
    subject.runner_count = 100000
    subject.runner_count.should == 100000
  end
end
