ENV["RACK_ENV"] = "production"

require "rubygems"
require "bundler"
Bundler.require
require File.expand_path "../sinatra.rb", __FILE__

run Sinatra::Application
