class AddSectionsInFeedColumn < ActiveRecord::Migration

  def self.up
    add_column "sections", "in_feed", :boolean, :null => false, :default => false
    Section.find_by_slug("geschichten").update_attributes!(:in_feed => true)
    Section.find_by_slug("blog").update_attributes!(:in_feed => true)
  end

  def self.down
    remove_column "sections", "in_feed"
  end

end