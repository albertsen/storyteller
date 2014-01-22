class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table "users", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column "username",      :string
      t.column "password_salt", :string, :null => false, :limit => 8
      t.column "password_hash", :string, :null => false, :limit => 64
      t.column "last_login",    :datetime
      t.column "auth_token",    :string, :limit => 64      
    end
    add_index "users", ["username"], :name => "u_username_idx", :unique => true
    add_index "users", ["auth_token"], :name => "u_auth_token_idx", :unique => true
  end
  
  def self.down
    drop_table "users"
  end

end