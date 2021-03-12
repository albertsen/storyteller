#!/usr/bin/env ruby
require "sinatra"
require "yaml"
require "rdiscount"

set :bind, '0.0.0.0'
set :port, 3000

SITE_DIR = ENV["SITE_DIR"] || settings.root
STORIES_DIR = File.join(SITE_DIR, "stories")
CONFIG=YAML.load_file(File.join(SITE_DIR, "config.yaml")) 
MAIN_TITLE=CONFIG["main_title"]
STORY_TITLE_PREFIX=CONFIG["story_title_prefix"]

get "/" do
	stories_file = "#{STORIES_DIR}/index.yaml"
	stories = if File.exists?(stories_file)
		YAML.load_file stories_file
	else
		{}
	end
	show :index, :title => MAIN_TITLE, :stories => stories
end

get "/stories/:story.:ext" do
	slug = params[:story]
	ext = params[:ext]
	file = "#{STORIES_DIR}/#{slug}/#{slug}.#{ext}"
	send_file file
end


get "/stories/:story" do
	slug = params[:story]
	file = "#{STORIES_DIR}/#{slug}/#{slug}.md"
	unless File.exists? file
		halt 404, "Does not exist: #{slug}"
	end
	puts file
	content = File.read file, :encoding => "UTF-8"
	i = content.index "="
	title = content[0..(i - 1)].strip
	title.gsub!(/(<[^>]*>)|\n|\t/s) {" "}
	text = RDiscount.new(content).to_html
	show :story, :title => "#{STORY_TITLE_PREFIX}: #{title}", :story_title => title, :story_text => text, :slug => slug
end

def show(template, locals = {})
	erb template, :layout => :layout, :locals => locals
end
