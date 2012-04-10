require 'spec_helper'

describe MultiSpork::Main do
  subject do
    MultiSpork::Main.new(
      :test_cmd => "bundle exec rspec --drb",
      :test_surfix => "_spec.rb",
      :banner => "Usage: multi_rspec [option] [spec_dir...] [spec_file...]",
      :reducer => MultiSpork::RSpecReducer.new
    )
  end

  describe "parse_options" do
    context "when --require is specified" do
      it "requires the specified file" do
        ARGV.replace [
          "-r",
          File.expand_path(File.dirname(__FILE__) + '/../../spec_test_files/dummy.rb'),
          "-w",
          "2"
        ]
        subject.parse_options
        $dummy.should be_true
      end
    end

    context "when --format is specified" do
      it "saves the specified formatter" do
        ARGV.replace [
          "-f",
          "DummyFormatter",
          "-w",
          "2"
        ]
        subject.parse_options
        subject.formatter_class_name.should == "DummyFormatter"
      end
    end
  end

  describe "run" do
    context "when a formatter is specified" do
      class DummyFormatter
        class << self
          attr_accessor :duration, :total, :failures, :pending
        end

        def initialize(_); end

        def dump_summary(duration, total, failures, pending)
          self.class.duration = duration
          self.class.total = total
          self.class.failures = failures
          self.class.pending = pending
        end
      end
      
      it "feeds it with the test results" do
        previous_stdout = $stdout
        $stdout = StringIO.new
        begin
          subject.stub!(:formatter_class_name).and_return("DummyFormatter")
          subject.stub!(:paths).and_return(['a', 'b'])
          subject.stub!(:worker).and_return(2)
          subject.should_receive(:parse_options).and_return(true)
          MultiSpork::TestExecutor.
            should_receive(:run_in_parallel).
            with(subject.test_cmd, anything, subject.worker).
            and_return(
              [
                true,
                [
                  "10 examples, 4 failures, 2 pending",
                  "5 examples, 1 failure, 1 pending"
                ]
              ]
            )
          subject.should_receive(:exit).with(true)
          subject.run
          DummyFormatter.duration.should >= 0
          DummyFormatter.total.should == 15
          DummyFormatter.failures.should == 5
          DummyFormatter.pending.should == 3
        ensure
          $stdout = previous_stdout
        end
      end
    end
  end

end