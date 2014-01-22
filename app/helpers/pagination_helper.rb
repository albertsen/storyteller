require "uri"

module PaginationHelper

  def url_for_page(page)
    url = request.path
    params = request.query_parameters
    params.delete "page"
    params = request.query_parameters.inject([]) do |p,(k,v)|
      p << "#{k}=#{v}"
    end
    params << "page=#{page}"
    query_string = params.join "&"
    URI.escape "#{url}?#{query_string}"
  end

end