class AddItemsOrderColumn < ActiveRecord::Migration

  def self.up
    add_column "items", "order", :integer, :null => false, :default => 0
    add_index "items", ["created_at", "order"], :name => "i_order_idx"
  end

  def self.down
    remove_column "items", "order"
  end

end