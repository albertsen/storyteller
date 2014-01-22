class CreateContactRequests < ActiveRecord::Migration

  def self.up
    create_table "contact_requests", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column      "sender",         :string,      :length => 255
      t.column      "sender_email",   :string,      :length => 255
      t.column      "body",           :mediumtext,  :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table "contact_requests"
  end

end