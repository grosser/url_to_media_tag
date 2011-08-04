module UrlToMediaTag
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  DEFAULTS = {
    :width => 640,
    :height => 480
  }

  def self.video_iframe(url, options)
    options = {:src => url, :class => "url-to-media-tag-video", :frameborder => 0}.merge(options)
    tag(:iframe, options)
  end

  def self.tag(name, options)
    options = options.map{|k,v| "#{k}=\"#{v}\"" }.sort.join(" ")
    %{<#{name} #{options}></#{name}>}
  end

  def self.convert(url, options={})
    options = DEFAULTS.merge(options)

    # prevent any kind of html or xss
    return if url.include?('>') or url.include?('<')

    result = case url

    # youtube
    when /http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?|http:\/\/(www.)?youtu\.be\/([A-Za-z0-9._%-]*)?/
      youtube_id = $2 || $5
      video_iframe "http://www.youtube.com/embed/#{youtube_id}", options

    # vimeo
    when /http:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/
      vimeo_id = $2
      show_title = "title=0" unless options.delete(:show_title)
      show_byline = "byline=0" unless options.delete(:show_byline)
      show_portrait = "portrait=0" unless options.delete(:show_portrait)
      query_string_variables = [show_title, show_byline, show_portrait].compact.join("&")
      query_string = "?" + query_string_variables unless query_string_variables.empty?

      video_iframe "http://player.vimeo.com/video/#{vimeo_id}#{query_string}", options

    # image
    when /https?:\/\/\S+\.(jpe?g|gif|png|bmp|tif)(\?\S+)?/i
      tag(:img, options.merge(:src => $&))
    end

    result = result.html_safe if result.respond_to?(:html_safe)
    result
  end
end
