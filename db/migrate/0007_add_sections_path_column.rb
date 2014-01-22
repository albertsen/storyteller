class AddSectionsPathColumn < ActiveRecord::Migration

  def self.up
    add_column "sections", "path", :string, :null => true, :length => 255
    Section.find_by_slug("geschichten").update_attributes!(:path => "/" )
  end

  def self.down
    remove_column "sections", "path"
  end

end