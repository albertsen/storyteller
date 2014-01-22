require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  def test_generate_slug_with_title
    s = Story.create! :title => "Ich bin, ein, täst(?)", :body => "Body", :sections => [sections(:blog)]
    assert_not_nil s.slug, "Slug"
    assert_equal "ich-bin-ein-taest", s.slug, "Slug"
  end

  def test_generate_slug_without_title
    p = BlogPost.create! :body => "Body", :sections => [sections(:blog)]
    assert_nil p.slug, "Slug"
  end

    
end
