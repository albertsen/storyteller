module Pagination
  
  def paginate(params, count, limit)
    current_page = params[:page].to_i
    current_page = 1 if current_page == 0
    page_count = (count.to_f / limit.to_f).ceil
    current_page = page_count if current_page > page_count
    previous_page = current_page - 1 if current_page > 1
    next_page = current_page + 1 if current_page < page_count
    return [current_page, previous_page, next_page]
  end
  
end