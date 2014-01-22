class SectionsController < ApplicationController

  helper :date
  helper :text
  
  include Pagination

  def show
    slug = params[:slug]
    unless slug.blank?
      @section = Section.find_by_slug slug
      unless @section
        render_not_found
      else
        count = @section.items.size
        if @section.page_size > 0
          @current_page, @previous_page, @next_page = paginate(params, count, @section.page_size)
        end
        @items = @section.find_items(@current_page || 0)
      end
      @title = @section.name
      @subheader_link = @section.path
      render_item_index(@section)
    else
      render_not_found
    end
  end
  
  protected
  
  def render_item_index(section)
    if File.exist?("#{RAILS_ROOT}/app/views/items/#{section.slug}/index.haml")
      render :template => "/items/#{section.slug}/index"
    else
      render :template => "/items/index"
    end
  end

end