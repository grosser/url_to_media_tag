require File.expand_path('spec/spec_helper')

describe UrlToMediaTag do
  it "has a VERSION" do
    UrlToMediaTag::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  describe 'convert' do
    it "converts youtube" do
      expected = "<iframe class=\"url-to-media-tag-video\" frameborder=\"0\" height=\"480\" src=\"http://www.youtube.com/embed/kW-dS4otEZU\" width=\"640\"></iframe>"
      UrlToMediaTag.convert('http://www.youtube.com/watch?v=kW-dS4otEZU').should == expected
    end

    it "converts vimeo" do
      expected = "<iframe class=\"url-to-media-tag-video\" frameborder=\"0\" height=\"480\" src=\"http://player.vimeo.com/video/26881896?title=0&byline=0&portrait=0\" width=\"640\"></iframe>"
      UrlToMediaTag.convert('http://vimeo.com/26881896').should == expected
    end

    it "converts images" do
      UrlToMediaTag.convert('http://foo.com/foo.jpg').should == "<img height=\"480\" src=\"http://foo.com/foo.jpg\" width=\"640\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.gif').should == "<img height=\"480\" src=\"http://foo.com/foo.gif\" width=\"640\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.png').should == "<img height=\"480\" src=\"http://foo.com/foo.png\" width=\"640\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.jpeg').should == "<img height=\"480\" src=\"http://foo.com/foo.jpeg\" width=\"640\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.JPG').should == "<img height=\"480\" src=\"http://foo.com/foo.JPG\" width=\"640\"></img>"
    end

    it "converts images with ?" do
      UrlToMediaTag.convert('http://foo.com/foo.jpg?foo=bar').should == "<img height=\"480\" src=\"http://foo.com/foo.jpg?foo=bar\" width=\"640\"></img>"
    end

    it "does not convert unknown" do
      UrlToMediaTag.convert('xxx').should == nil
    end

    it "marks output as html_safe" do
      UrlToMediaTag.convert('http://vimeo.com/26881896').html_safe?.should == true
    end

    it "prevents xss" do
      UrlToMediaTag.convert('http://vimeo.com/26881896<').should == nil
      UrlToMediaTag.convert('http://vimeo.com/26881896>').should == nil
    end
  end
end
