#!/usr/local/bin/ruby
require "sinatra"
require "yaml"
require "rdiscount"

set :bind, '0.0.0.0'
set :port, 8000

ROOT = settings.root
STORIES_DIR = "#{ROOT}/stories"
STORIES_CACHE_DIR = "#{ROOT}/.cache/stories"

configure do
	FileUtils.mkdir_p STORIES_CACHE_DIR
end

get "/" do
	stories_file = "#{STORIES_DIR}/index.yaml"
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
	title, content = read_story story
	unless story
		halt 404, "Not found: /stories/#{story}"
	end
	show :story, :title => "Jürgen Albertsen: #{title}", :story_title => title, :story_text => content
end

def show(template, locals = {})
	erb template, :layout => :layout, :locals => locals
end

def read_story(story)
	story_file = "#{STORIES_DIR}/#{story}.md"
	unless File.exists? story_file
		return nil
	end
	cache_file = "#{STORIES_CACHE_DIR}/#{story}.cache"
	if FileUtils.uptodate? cache_file, [story_file]
		return read_story_from_cache cache_file
	else
		title, content = read_story_from_original story_file
		update_cache_file(cache_file, title, content)
		return [title, content]
	end
end

def read_story_from_original(file)
	contents = File.read file, {:encoding => "UTF-8"}
	i = contents.index "\n"
	title = contents[0..i]
	text = RDiscount.new(contents[i..-1]).to_html.force_encoding('UTF-8')
	return [title, text]
end

def update_cache_file(cache_file, title, content)
	File.open(cache_file, "w:UTF-8") do |file|
		file.puts title
		file.puts ""
		file.puts content
	end
end

def read_story_from_cache(file)
	puts "Reading from cache #{file}"
	contents = File.read file, {:encoding => "UTF-8"}
	i = contents.index "\n"
	return [contents[0..i], contents[i..-1]]
end