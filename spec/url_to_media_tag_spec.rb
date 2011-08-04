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
      UrlToMediaTag.convert('http://foo.com/foo.jpg').should == "<img src=\"http://foo.com/foo.jpg\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.gif').should == "<img src=\"http://foo.com/foo.gif\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.png').should == "<img src=\"http://foo.com/foo.png\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.jpeg').should == "<img src=\"http://foo.com/foo.jpeg\"></img>"
      UrlToMediaTag.convert('http://foo.com/foo.JPG').should == "<img src=\"http://foo.com/foo.JPG\"></img>"
    end

    it "converts images with ?" do
      UrlToMediaTag.convert('http://foo.com/foo.jpg?foo=bar').should == "<img src=\"http://foo.com/foo.jpg?foo=bar\"></img>"
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

    describe 'settings' do
      it "uses directly given settings" do
        UrlToMediaTag.convert('http://foo.com/foo.jpg', :foo => 'bar').should == "<img foo=\"bar\" src=\"http://foo.com/foo.jpg\"></img>"
      end

      it "uses indirectly given settings" do
        UrlToMediaTag.convert('http://foo.com/foo.jpg', :settings => {:image => {:foo => 'bar'}}).should == "<img foo=\"bar\" src=\"http://foo.com/foo.jpg\"></img>"
      end

      it "does not use not-matching settings" do
        UrlToMediaTag.convert('http://foo.com/foo.jpg', :settings => {:video => {:foo => 'bar'}}).should == "<img src=\"http://foo.com/foo.jpg\"></img>"
      end

      it "users more precise settings" do
        UrlToMediaTag.convert('http://vimeo.com/26881896', :settings => {:video => {:foo => 'bar'}, :vimeo => {:foo => 'baz'}}).should include('foo="baz"')
      end

      it "overwrites default settings" do
        UrlToMediaTag.convert('http://foo.com/foo.jpg', :foo => 'bar', :settings => {:image => {:foo => 'baz'}}).should include('foo="baz"')
      end

      it "can take options from settings" do
        UrlToMediaTag.convert('http://vimeo.com/26881896').should include('title=0')
        UrlToMediaTag.convert('http://vimeo.com/26881896', :settings => {:vimeo => {:show_title => true}}).should_not include('title=0')
      end
    end
  end
end
