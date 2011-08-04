module UrlToMediaTag
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  VIDEO_DEFAULTS = {
    :width => 640,
    :height => 480,
    :class => "url-to-media-tag-video",
    :frameborder => 0
  }

  def self.video_iframe(url, options)
    options = {:src => url}.merge(VIDEO_DEFAULTS).merge(options)
    tag(:iframe, options)
  end

  def self.tag(name, options)
    options = options.map{|k,v| "#{k}=\"#{v}\"" }.sort.join(" ")
    %{<#{name} #{options}></#{name}>}
  end

  # :video, :x => 1, :settings => {:video => {:width => 300}}
  # --> {:x => 1, :width => 300}
  def self.merge_settings(*args)
    options = args.pop.dup
    raise unless options.kind_of?(Hash)
    settings = options.delete(:settings) || {}
    args.each{|type| options.merge!(settings[type] || {}) }
    options
  end

  def self.convert(url, options={})
    options = options.dup

    # prevent any kind of html or xss
    return if url.include?('>') or url.include?('<')

    result = case url

    # youtube
    when /http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?|http:\/\/(www.)?youtu\.be\/([A-Za-z0-9._%-]*)?/
      options = merge_settings(:video, :vimeo, options)
      youtube_id = $2 || $5
      video_iframe "http://www.youtube.com/embed/#{youtube_id}", options

    # vimeo
    when /http:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/
      options = merge_settings(:video, :vimeo, options)

      vimeo_id = $2
      show_title = "title=0" unless options.delete(:show_title)
      show_byline = "byline=0" unless options.delete(:show_byline)
      show_portrait = "portrait=0" unless options.delete(:show_portrait)
      query_string_variables = [show_title, show_byline, show_portrait].compact.join("&")
      query_string = "?" + query_string_variables unless query_string_variables.empty?

      video_iframe "http://player.vimeo.com/video/#{vimeo_id}#{query_string}", options

    # image
    when /https?:\/\/\S+\.(jpe?g|gif|png|bmp|tif)(\?\S+)?/i
      options = merge_settings(:image, options)
      tag(:img, options.merge(:src => $&))
    end

    result = result.html_safe if result.respond_to?(:html_safe)
    result
  end
end
