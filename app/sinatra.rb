#!/usr/bin/env ruby
require "sinatra"
require "yaml"
require "rdiscount"
require "csv"

set :bind, '0.0.0.0'
set :port, 3000

ROOT = settings.root
STORIES_DIR = ENV["STORIES_DIR"] || "#{ROOT}/stories"
DATA_DIR = "#{ROOT}/data"

%w{plotdevice.org www.plotdevice.org}.each do |h|
	get '/', :host_name => h do
  		redirect 'http://www.juergenalbertsen.de', 301
	end
end

get "/" do
	stories_file = "#{STORIES_DIR}/index.yaml"
	stories = if File.exists?(stories_file)
		YAML.load_file stories_file
	else
		{}
	end
	show :index, :title => "Jürgen Albertsen: Geschichten", :stories => stories
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
	content = File.read file, {:encoding => "UTF-8"}
	i = content.index "="
	title = content[0..(i - 1)].strip
	title.gsub!(/(<[^>]*>)|\n|\t/s) {" "}
	text = RDiscount.new(content).to_html
	show :story, :title => "Jürgen Albertsen: #{title}", :story_title => title, :story_text => text, :slug => slug
end

def show(template, locals = {})
	erb template, :layout => :layout, :locals => locals
end
