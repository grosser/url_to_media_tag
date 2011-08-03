$LOAD_PATH.unshift 'lib'
require 'url_to_media_tag'

class String
  def html_safe
    @html_safe = true
    self
  end

  def html_safe?
    @html_safe
  end
end
