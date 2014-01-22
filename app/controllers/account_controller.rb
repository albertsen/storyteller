class AccountController < ApplicationController

  before_filter :determine_request_uri
  
  def login
    if session[:user]
      redirect_to_request_uri
      return
    end
    if request.post?
      @login_credentials = LoginCredentials.new params[:credentials]
      unless @login_credentials.valid?
        return
      end
      user = User.try_to_authenticate @login_credentials.username, @login_credentials.password
      if user.nil?
        flash.now[:error] = "Wrong username or password"
      else
        session[:user] = user.id
        if @login_credentials.remember_me?
          user.remember_me 
          cookies[:auth_token] = {:value => user.auth_token, :expires => 90.days.from_now}
        else
          user.forget_me
          cookies.delete :auth_token
        end
        redirect_to_request_uri
      end
    else
      @login_credentials = LoginCredentials.new :remember_me => true
    end
  end
  
  def logout
    if session[:user]
      user = User.find session[:user]
      user.forget_me
    end
    cookies.delete :auth_token
    reset_session
    redirect_to_request_uri
  end
  
  private
  
  def determine_request_uri 
    @request_uri = params[:request_uri]
    params.delete :request_uri
  end
  
  def redirect_to_request_uri
    if @request_uri
      redirect_to @request_uri
    else
      redirect_to root_url
    end
  end

end