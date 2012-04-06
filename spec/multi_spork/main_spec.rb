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
    context "when a ruby file is specified" do
      it "should require it" do
        ARGV.replace [
          "-r",
          File.expand_path(File.dirname(__FILE__) + '/../../spec_test_files/dummy.rb'),
          "-w",
          "1"
        ]
        subject.parse_options
        $dummy.should be_true
      end
    end
  end

end