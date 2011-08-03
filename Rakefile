task :default do
  sh "rspec spec/"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'url_to_media_tag'
    gem.summary = "Convert a Url to image or video embed"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
