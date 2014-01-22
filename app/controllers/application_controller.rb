class ApplicationController < ActionController::Base

  include UrlHelper

  helper :all
  layout "main"
  before_filter :login_from_cookie
  before_filter :load_user
  protect_from_forgery
  
  protected
  
  def render_not_found
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  def login_from_cookie
    if session[:user].nil? && cookies[:auth_token]
      user = User.find_by_auth_token(cookies[:auth_token])
      if user
        user.logged_in
        session[:user] = user.id
      end
    end
  end
  
  def load_user
    @user = User.find session[:user] if session[:user]
  end
  

end
