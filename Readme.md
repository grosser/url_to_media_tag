Convert a Url to image or video embed.

Supports:

 - Youtube
 - Vimeo
 - ... soon more ...

Install
=======
    sudo gem install url_to_media_tag
Or

    rails plugin install git://github.com/grosser/url_to_media_tag.git

Usage
=====
### Convert

    UrlToMediaTag.convert('http://www.youtube.com/watch?v=kW-dS4otEZU') # -> <iframe ...>
    UrlToMediaTag.convert(url, :width => 480, :height => 320)           # -> <iframe ...>
    UrlToMediaTag.convert('no-url')                                     # -> nil

### Find

    urls = text.scan(%r{https?://[^\s]*})

### Replace

    text_with_embed = text.gsub(%r{https?://[^\s]*}){|url| UrlToMediaTag.convert(url) }

Alternative
===========
 - [auto_html](https://github.com/dejan/auto_html) If you want more fancy stuff like auto-linking + strip-tags + active-record-integration (and more dependencies / C-extensions)

TODO
====
 - support images
 - let users choose which providers to convert

Author
======
Filter logic borrowed from Dejan Simic`s [auto_html](https://github.com/dejan/auto_html) MIT-LICENSE

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
