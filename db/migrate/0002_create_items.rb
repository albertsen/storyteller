class CreateItems < ActiveRecord::Migration

  def self.up
    create_table "items", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column      "slug",       :string,      :length => 255
      t.column      "title",      :text
      t.column      "teaser",     :text
      t.column      "body",       :mediumtext,  :null => false
      t.column      "type",       :string,      :null => false, :length => 50
      t.column      "section_id", :integer,     :null => false
      t.column      "visible",    :boolean,     :null => false, :default => true
      t.timestamps
    end
    add_index "items", ["slug"], :name => "i_slug_idx"
    add_index "items", ["visible"], :name => "i_visible_idx"
    add_index "items", ["slug", "visible"], :name => "i_slug_visible_idx"
    add_index "items", ["section_id"], :name => "i_section_idx"
    add_index "items", ["section_id", "visible"], :name => "i_section_visible_idx"
    execute "CREATE FULLTEXT INDEX i_fulltext_idx ON items (title, teaser, body)"
  end

  def self.down
    drop_table "items"
  end

end