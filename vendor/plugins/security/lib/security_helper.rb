module Security

  module SecurityHelper
    def logged_in?
      return !session[:user].nil?
    end  

    def user_has_permission_for?(object)
      return object.user_id == session[:user]
    end

    def with_permission_for(object, &block)
      raise ArgumentError, "No block given" unless block_given?  
      if user_has_permission_for?(object)
        yield
      end
    end

    def without_permission_for(object, &block)
      raise ArgumentError, "No block given" unless block_given?  
      if !user_has_permission_for?(object)
        yield
      end
    end    
  end

end