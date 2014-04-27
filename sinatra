#!/usr/local/bin/ruby
require "sinatra"
require "yaml"
require "rdiscount"

set :bind, '0.0.0.0'
set :port, 8000

root = settings.root

get "/" do
	stories_file = "#{root}/stories/index.yaml"
	puts stories_file
	stories = if File.exists?(stories_file)
		YAML.load_file stories_file
	else
		{}
	end
	puts stories
	show :index, :title => "Jürgen Albertsen", :stories => stories
end

get "/stories/:story" do
	story = params[:story]
	stories_file = "#{root}/stories/#{story}.md"
	puts stories_file
	unless File.exists? stories_file
		halt 404, "Not found: /stories/#{story}"
	end
	contents = File.read stories_file
	i = contents.index "\n"
	story_title = contents[0..i]
	story_text = RDiscount.new(contents[i..-1]).to_html.force_encoding('UTF-8')
	show :story, :title => "Jürgen Albertsen: #{story_title}", :story_title => story_title, :story_text => story_text
end

def show(template, locals = {})
	erb template, :layout => :layout, :locals => locals
end