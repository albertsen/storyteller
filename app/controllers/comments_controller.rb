class CommentsController < ApplicationController

  protect :except => [:feed]
  helper :comments
  helper :text
  
  def show
    @comment = Comment.find params[:id]
    render :action => "show", :layout => "popup"
  end

  def destroy
    comment = Comment.find params[:id]
    comment.destroy
    redirect_to deep_item_url(comment.item)
  end
  
  def feed
    @comments = Comment.find_all
    render :template => "comments/rss", :layout => false
  end

end