ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  msg = instance.error_message
  msg = msg.kind_of?(Array) ? msg.join(", ") : msg
  "<span class=\"field_with_error\">#{html_tag}</span>" 
end