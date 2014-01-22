class ContactController < ApplicationController
  
  def contact
    @contact_request = ContactRequest.new
    if request.post?
      @contact_request.attributes = params[:contact_request]    
      if @contact_request.save
        ContactRequestNotifier.deliver_notification @contact_request
        render :action => "thanks"
      else
        render :action => "contact"
      end
    else
      render :action => "contact"
    end
  end
  
end