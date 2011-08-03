require File.expand_path('spec/spec_helper')

describe UrlToMediaTag do
  it "has a VERSION" do
    UrlToMediaTag::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
