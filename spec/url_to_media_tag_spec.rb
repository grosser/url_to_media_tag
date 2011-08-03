require File.expand_path('spec/spec_helper')

describe UrlToMediaTag do
  it "has a VERSION" do
    UrlToMediaTag::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  describe 'convert' do
    it "converts youtube" do
      expected = "<iframe class=\"youtube-player\" type=\"text/html\" width=\"640\" height=\"480\" src=\"http://www.youtube.com/embed/kW-dS4otEZU\" frameborder=\"\"></iframe>"
      UrlToMediaTag.convert('http://www.youtube.com/watch?v=kW-dS4otEZU').should == expected
    end

    it "converts vimeo" do
      expected = "<iframe src=\"http://player.vimeo.com/video/26881896?title=0&byline=0&portrait=0\" width=\"640\" height=\"480\" frameborder=\"0\"></iframe>"
      UrlToMediaTag.convert('http://vimeo.com/26881896').should == expected
    end

    it "does not convert unknown" do
      UrlToMediaTag.convert('xxx').should == nil
    end

    it "marks output as html_safe" do
      UrlToMediaTag.convert('http://vimeo.com/26881896').html_safe?.should == true
    end
  end
end
