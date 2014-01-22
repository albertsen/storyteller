# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

  create_table "comments", :force => true do |t|
    t.string   "author"
    t.string   "author_url"
    t.string   "author_email"
    t.text     "body",         :limit => 16777215, :null => false
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.integer  "item_id",                          :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["item_id"], :name => "c_item_id_idx"

  create_table "contact_requests", :force => true do |t|
    t.string   "sender"
    t.string   "sender_email"
    t.text     "body",         :limit => 16777215, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "slug"
    t.text     "title"
    t.text     "teaser"
    t.text     "body",       :limit => 16777215,                   :null => false
    t.string   "type",                                             :null => false
    t.integer  "section_id",                                       :null => false
    t.boolean  "visible",                        :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order",                          :default => 0,    :null => false
  end

  add_index "items", ["created_at", "order"], :name => "i_order_idx"
  add_index "items", ["section_id", "visible"], :name => "i_section_visible_idx"
  add_index "items", ["section_id"], :name => "i_section_idx"
  add_index "items", ["slug", "visible"], :name => "i_slug_visible_idx"
  add_index "items", ["slug"], :name => "i_slug_idx"
  add_index "items", ["title", "teaser", "body"], :name => "i_fulltext_idx"
  add_index "items", ["visible"], :name => "i_visible_idx"

  create_table "media", :force => true do |t|
    t.string   "filename",   :null => false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["filename"], :name => "a_filename_idx"

  create_table "sections", :force => true do |t|
    t.string   "slug",                             :null => false
    t.text     "name",                             :null => false
    t.integer  "page_size",     :default => 0,     :null => false
    t.integer  "order",         :default => 0,     :null => false
    t.boolean  "on_home_page",  :default => true,  :null => false
    t.boolean  "in_navigation", :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path"
    t.boolean  "in_feed",       :default => false, :null => false
  end

  add_index "sections", ["slug"], :name => "s_slug_idx", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_salt", :limit => 8,  :null => false
    t.string   "password_hash", :limit => 64, :null => false
    t.datetime "last_login"
    t.string   "auth_token",    :limit => 64
  end

  add_index "users", ["auth_token"], :name => "u_auth_token_idx", :unique => true
  add_index "users", ["username"], :name => "u_username_idx", :unique => true

end
