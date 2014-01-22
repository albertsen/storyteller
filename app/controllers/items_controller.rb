class ItemsController < ApplicationController

  helper :date
  helper :text
  helper :comments
  helper :pdf
  
  protect :except => [:index, :show, :add_comment]
  has_rakismet

  def index
    render_not_found
  end
  
  def show
    with_item_found do
      @comment = Comment.new
      @comment.author = cookies[:author]
      @comment.author_url = cookies[:author_url]
      @comment.author_email = cookies[:author_email]
      render :action => "show"
    end
  end
  
  def new
    @item = create_item_instance params
    @item.section = @item.default_section
    @item.visible = true
    render :action => "new"
  end
  
  def create      
    @item = create_item_instance params
    if @item.save
      if @item.visible
        redirect_to deep_item_url(@item)
      else
        flash[:notice] = "Item created"
        render :action => "new"
      end
    else
      render :action => "new"
    end
  end
  
  def edit
    @item = Item.find params[:id]
  end
  
  def update
    @item = Item.find params[:id]
    @item.attributes = params[:item]
    if @item.save
      if @item.visible
        redirect_to deep_item_url(@item)
      else
        flash[:notice] = "Item saved"
        render :action => "edit"
      end
    else
      render :action => "edit"
    end
  end
  

  def destroy
    @item = Item.find params[:id]
    @item.destroy
    redirect_to root_url
  end
  
  def add_comment
    with_item_found do
      @comment = Comment.new params[:comment]
      @comment.item = @item
      @comment.user = @user if logged_in?
      if @comment.valid?
        @comment.save_with_validation(false) unless @comment.spam?
        expires = 1.year.from_now
        cookies[:author] = { :value => @comment.author, :expires => expires }
        cookies[:author_url] = { :value => @comment.author_url, :expires => expires }
        cookies[:author_email] = { :value => @comment.author_email, :expires => expires }
        redirect_to params[:redirect_uri]
      else
        render :action => "show"
      end
    end
  end
  
  def invisible
    @items = Item.find_all_by_visible false
    render :action => "invisible"
  end
  
  private
  
  def create_item_instance(params)
    type = params[:type]
    raise ArgumentError, "No type given in params" unless type
    item_class = Class.for_name type
    item = item_class.new
    raise "Invalid item class: #{item_class.name}" unless item.is_a?(Item)
    item.attributes = params[:item]   
    item
  end
  
  def with_item_found(&block)
    raise ArgumentError, "No block given" unless block_given?
    id = params[:id]
    slug = params[:slug]
    @item = Item.find_item id, slug
    if @item
      yield
    else
      render_not_found
    end
  end

end