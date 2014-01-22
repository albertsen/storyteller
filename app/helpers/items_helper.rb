module ItemsHelper
  
  def section_selected?(item, section)
    action = controller.action_name
    if %w{create update}.include?(action)
      (params[:item][:section_ids] || []).include?(section.id.to_s)
    else
      if item.new_record?
        item.default_sections.include? section
      else
        item.sections.include? section
      end
    end
  end
  
  def item_overview_template(item)
    if File.exist? "#{RAILS_ROOT}/app/views/items/#{item.section.slug}/_item.haml"
      "items/#{item.section.slug}/item"
    else
      "items/item"
    end
  end
  
  def describe_item_action(item)
    if item.new_record?
      "erstellen"
    else
      "bearbeiten"
    end
  end
  
end