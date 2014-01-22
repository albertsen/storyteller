class HomeController < ApplicationController
  
  helper :text
  
  def index
    @sections = Section.find_all_for_home
    @bait = Item.find_bait
    render :index, :layout => "home"
  end
  
end