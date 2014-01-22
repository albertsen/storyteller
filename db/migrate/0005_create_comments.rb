class CreateComments < ActiveRecord::Migration

  def self.up
    create_table "comments", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column      "author",         :string,      :length => 255
      t.column      "author_url",     :string,      :length => 255
      t.column      "author_email",   :string,      :length => 255
      t.column      "body",           :mediumtext,  :null => false
      t.column      "user_ip",        :string
      t.column      "user_agent",     :string
      t.column      "referrer",       :string
      t.column      "item_id",        :integer,     :null => false
      t.column      "user_id",        :integer
      t.timestamps
    end
    add_index "comments", ["item_id"], :name => "c_item_id_idx"
  end

  def self.down
    drop_table "comments"
  end

end