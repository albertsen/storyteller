class CreateMedia < ActiveRecord::Migration

  def self.up
    create_table "media", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column      "filename",   :string,      :null => false, :length => 255
      t.column      "type",       :string,      :length => 50      
      t.timestamps
    end
    add_index "media", ["filename"], :name => "a_filename_idx"
  end

  def self.down
    drop_table "media"
  end

end