module UrlHelper
  
  def deep_item_url(item, options = {})
    if item.has_slug?
      item_with_slug_url(item.id, item.slug, options)
    else
      item_url(item.id, options)
    end  
  end
  
end