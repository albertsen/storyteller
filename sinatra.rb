#!/usr/local/bin/ruby
require "sinatra"

set :port, 8000

get "/" do
	erb :index
end