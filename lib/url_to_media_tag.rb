module UrlToMediaTag
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  DEFAULTS = {
    :width => 640,
    :height => 480
  }

  def self.convert(url, options={})
    options = DEFAULTS.merge(options)

    result = case url

    # youtube
    when /http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?|http:\/\/(www.)?youtu\.be\/([A-Za-z0-9._%-]*)?/
      youtube_id = $2 || $5
      width = options[:width]
      height = options[:height]
      frameborder = options[:frameborder]
      %{<iframe class="youtube-player" type="text/html" width="#{width}" height="#{height}" src="http://www.youtube.com/embed/#{youtube_id}" frameborder="#{frameborder}"></iframe>}

    # vimeo
    when /http:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/
      vimeo_id = $2
      width = options[:width]
      height = options[:height]
      show_title = "title=0" unless options[:show_title]
      show_byline = "byline=0" unless options[:show_byline]
      show_portrait = "portrait=0" unless options[:show_portrait]
      frameborder = options[:frameborder] || 0
      query_string_variables = [show_title, show_byline, show_portrait].compact.join("&")
      query_string = "?" + query_string_variables unless query_string_variables.empty?

      %{<iframe src="http://player.vimeo.com/video/#{vimeo_id}#{query_string}" width="#{width}" height="#{height}" frameborder="#{frameborder}"></iframe>}
    end

    result = result.html_safe if result.respond_to?(:html_safe)
    result
  end
end
