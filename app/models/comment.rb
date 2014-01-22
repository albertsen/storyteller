# encoding: utf-8
class Comment < ActiveRecord::Base
  
  include UrlHelper
  
  belongs_to :item
  belongs_to :user
  has_rakismet :only => :create,
               :content => :body,
               :comment_type => proc { "comment" }

  validates_presence_of :author, :message => "Name fehlt", :unless => :has_user?
  validates_length_of :author, :maximum => 30, :message => "Name zu lang. Nur bis zu {{count}} Zeichen erlaubt.", :unless => Proc.new { |c| c.author.blank? }
  
  validates_presence_of :author_email, :message => "E-Mail-Adresse fehlt", :unless => :has_user?
  validates_email_format_of :author_email, :message => "E-Mail-Adresse ungültig", :unless => Proc.new { |c| c.author_email.blank? }
  validates_length_of :author_email, :maximum => 100, :message => "E-Mail-Adresse zu lang. Nur bis zu {{count}} Zeichen erlaubt.", :unless => Proc.new { |c| c.author_email.blank? }

  validates_url_format_of :author_url, :message => "Homepage-URL ungültig", :unless => Proc.new { |c| c.author_url.blank? }
  validates_length_of :author_url, :maximum => 255, :message => "Homepage-URL zu lang. Nur bis zu {{count}} Zeichen erlaubt.", :unless => Proc.new { |c| c.author_email.blank? }  
  
  validates_presence_of :body, :message => "Text fehlt"    
  validates_length_of :body, :maximum => 2000, :message => "Text zu lang. Nur bis zu {{count}} Zeichen erlaubt."
  
  def self.find_all
    all :limit => 10, :order => "created_at DESC"
  end
  
  def permalink
    deep_item_url(self.item)
  end
  
  def has_user?
    !self.user.blank?
  end
  
  def author_or_user
    if has_user?
      user.username
    else
      author
    end
  end
  
end