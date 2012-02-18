require 'spec_helper'

describe MultiSpork::TestResolver do
  shared_examples_for "resolves paths to files" do
    it "resolves paths to files" do
      files = MultiSpork::TestResolver.
        resolve(spec_paths, ".feature").
        sort
      files[0].should be_end_with("fa.feature")
      files[1].should be_end_with("f1a.feature")

    end
  end

  describe "resolve" do
    let(:spec_path) { File.expand_path("../../../spec_test_files", __FILE__) }

    context "when single root passed" do
      let(:spec_paths) { [spec_path] }
      it_should_behave_like "resolves paths to files"
    end

    context "when file and path passed" do
      let(:spec_paths) { [spec_path + "/set1", spec_path + "/fa.feature"] }
      it_should_behave_like "resolves paths to files"
    end

    context "when duplicates paths passed" do
      let(:spec_paths) { [spec_path] * 2 }
      it_should_behave_like "resolves paths to files"
    end
  end
end
