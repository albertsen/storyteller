class ContactRequest < ActiveRecord::Base
  
  validates_presence_of :sender, :message => "Name fehlt"
  validates_length_of :sender, :maximum => 30, :message => "Name zu lang. Nur bis zu {{count}} Zeichen erlaubt."
  
  validates_presence_of :sender_email, :message => "E-Mail-Adresse fehlt"
  validates_email_format_of :sender_email, :message => "E-Mail-Adresse ungültig", :unless => Proc.new { |cr| cr.sender_email.blank? }
  validates_presence_of :body, :message => "Text fehlt"    
  validates_length_of :body, :maximum => 2000, :message => "Text zu lang. Nur bis zu {{count}} Zeichen erlaubt."
  
end