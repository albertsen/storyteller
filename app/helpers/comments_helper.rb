module CommentsHelper
  
  def linked_author(comment)
    if comment.user
      link_to "#{comment.user.username}", root_url
    else
      if comment.author_url.blank?
        comment.author
      else
        link_to comment.author, comment.author_url
      end
    end
  end
  
  def number_of_comments(count)
    if count == 1
      "1 Kommentar"
    else
      "#{count} Kommentare"
    end
  end
  
  def comment_meta(comment)
    meta = "<b>#{linked_author(comment)}</b> am #{format_date(comment.created_at)}"
    if logged_in?
      info_url = url_for :controller => "comments", :id => comment.id, :action => "show"
      meta += %Q{ ( <a href="javascript:open_comment_info('#{info_url}')")>?</a>}
      meta += "|" + link_to("x", { :controller => "comments", :id => comment.id, :action => "destroy"}, :confirm => "Sure?")
      meta += ")"
    end
    meta += ":"
    meta
  end
    
end