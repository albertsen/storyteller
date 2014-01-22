class Section < ActiveRecord::Base

  has_many :items

  validates_presence_of :slug, :message => "Slug missing"
  validates_presence_of :name, :message => "Name missing"
  
  before_validation_on_create :set_page_size
  
  def self.find_all(options = {})
    options = {:order => "`order`"}.merge(options)
    find :all, options
  end
  
  def self.find_all_for_navigation
    find_all(:conditions => ["in_navigation = ?", true])    
  end
  
  def self.find_all_for_home
    find_all(:conditions => ["on_home_page = ?", true])
  end
  
  def self.find_all_by_slugs(slugs)
    find :all, :conditions => ["slug in (?)", slugs]
  end

  def find_items(page = 0)
    options = {:conditions => ["visible = ?", true], :order => "`order`, created_at DESC"}
    if page > 0
      if page_size.blank?
        raise ArgumentError, "Cannot find items for a particular page when no page size is specified" 
      end
      options.merge!({ :limit => page_size, :offset => (page - 1) * page_size })
    end
    items.find :all, options
  end
  
  def path
    self.attributes["path"] || "/#{self.slug}"
  end
  
  protected
  
  def set_page_size
    self.page_size = 0 unless self.page_size
  end

end
