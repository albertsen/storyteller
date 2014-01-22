# encoding: utf-8
class Item < ActiveRecord::Base

  MORE_BODY_MARKER = "<!--more-->"
  PAGE_SIZE = 10

  belongs_to :section
  has_many :comments, :order => "created_at"
  
  validates_presence_of :section, :message => "Item must belong to a section"
  
  after_create :generate_slug

  def self.find_item(id, slug)
    if slug
      find_by_id_and_slug_and_visible id, slug, true
    else
      find_by_id_and_visible id, true
    end
  end
  
  def self.count_search(expression)
    count :conditions => ["match(title, teaser, body) against (?) AND visible = ?", expression, true]
  end

  def self.search(expression, page = 0)
    options = {:conditions => ["match(title, teaser, body) against (?) AND visible = ?", expression, true]}
    options = merge_paging_options options, page
    find :all, options
  end
  
  def self.find_all(page = 0)
    options = {:conditions => ["visible = ?", true], :order => "created_at DESC"}
    options = merge_paging_options options, page
    find :all, options
  end
  
  def self.find_bait
    find :first, :conditions => ["sections.slug = ?", "bait"], :joins => [:section], :order => "created_at DESC"
  end

  def self.find_all_in_feed(limit = 10)
    find :all, :conditions => ["sections.in_feed = ? and items.visible = ?", true, true], :joins => [:section], :order => "created_at DESC", :limit => limit
  end
  
  def self.count_all
    count :conditions => ["visible = ?", true], :order => "created_at DESC"
  end

  def default_section
    Section.find_by_slug "blog"
  end

  def has_slug?
    !self.slug.blank?
  end
  
  def body_has_more_parts?
    self.body.include? MORE_BODY_MARKER
  end
  
  def first_body_part
    parts = body.split MORE_BODY_MARKER
    first_part = parts.first
    unless first_part.nil?
      first_part.strip
    else
      nil
    end
  end
  
  def identification
    self.title || self.id.to_s
  end
  
  protected
  
  def generate_slug
    if self.slug.blank? and !self.title.blank?
      slug = self.title.downcase
      slug.gsub! /[\s_\(\)\\:]/, "-"
      slug.gsub! /[,.\?!]/, ""
      {
        "ä" => "ae",
        "ö" => "oe",
        "ü" => "ue",
        "ß" => "ss"
      }.each { |u,r| slug = slug.gsub u, r }
      slug.gsub! /(^\-*|\-*$)/, ""
      slug.squeeze! "-"
      self.update_attribute :slug, slug
    end
  end
  
  def self.merge_paging_options(options, page)
    options.merge({ :limit => PAGE_SIZE, :offset => (page - 1) * PAGE_SIZE }) if page > 0
  end

end
