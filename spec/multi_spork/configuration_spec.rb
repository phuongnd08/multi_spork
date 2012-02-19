require 'spec_helper'

describe MultiSpork::Configuration do
  subject { MultiSpork::Configuration.new }

  it "has default value" do
    subject.worker_pool.should >= 1
  end

  it "can be changed" do
    subject.worker_pool = 100000
    subject.worker_pool.should == 100000
  end
end
