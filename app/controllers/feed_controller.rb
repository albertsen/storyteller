class FeedController < ApplicationController

  def index
    @items = Item.find_all_in_feed 10
    render :template => "/items/rss", :layout => false
  end
  
end