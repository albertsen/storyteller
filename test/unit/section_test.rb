require 'test_helper'

class SectionTest < ActiveSupport::TestCase


  def test_find_items_for_page_1
    do_test_find_items_for_page 1
  end
  
  def test_find_items_for_page_2
    do_test_find_items_for_page 2
  end
  
  def test_find_items_without_pages
    BlogSection.use_page_size nil
    do_test_find_items_for_page 0
  end

  def test_find_items_for_page_without_page_size
    BlogSection.use_page_size nil
    assert_raise ArgumentError do
      do_test_find_items_for_page 1  
    end
  end

  def do_test_find_items_for_page(page)
    section = sections(:blog)
    assert_not_nil section, "section"
    page_size = section.page_size
    items = (1..40).collect do |i|
      item = BlogPost.new :slug => i, :body => i
      time = i.minute.from_now
      item.updated_at = time
      item.created_at = time
      item.sections << section
      item.save
      item
    end
    items.reverse!
    db_items = section.find_items page
    unless page_size.blank?
      assert_equal section.page_size, db_items.size, "Size of items"
      assert_equal items[((page - 1) * page_size)..((page * page_size) - 1)].collect {|i| i.id }, db_items.collect {|i| i.id}
    else
      assert_equal items, db_items
    end
  end
  
end
