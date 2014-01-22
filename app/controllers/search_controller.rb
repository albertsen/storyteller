class SearchController < ApplicationController
  
  include Pagination
  helper :pagination
  
  def search
    expression = params[:s]
    unless expression.blank?
      count = Item.count_search expression
      @current_page, @previous_page, @next_page = paginate(params, count, 10)
      @items = Item.search(expression, @current_page || 0)
      @subtitle = %Q{Ergebnisse für &bdquo;#{expression}&ldquo;:}
    else
      count = Item.count_all
      @current_page, @previous_page, @next_page = paginate(params, count, 10)      
      @items = Item.find_all(@current_page || 0)
      @subtitle = "Alles:"
    end
    @title = "Suche"
    @subheader_link = search_path(:s => expression)
    render :template => "items/index"
  end
  
end