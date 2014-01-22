class CreateSections < ActiveRecord::Migration
  
  def self.up
    create_table "sections", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column      "slug",           :string,      :null => false
      t.column      "name",           :text,        :null => false
      t.column      "page_size",      :integer,     :null => false, :default => 0
      t.column      "order",          :integer,     :null => false, :default => 0
      t.column      "on_home_page",   :boolean,     :null => false, :default => true
      t.column      "in_navigation",  :boolean,     :null => false, :default => true
      t.timestamps
    end
    add_index "sections", ["slug"], :name => "s_slug_idx", :unique => true
  end
  
  def self.down
    drop_table "sections"
  end

end
