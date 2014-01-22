module Security
  
  module Protectable

    module ActionAccessRules    
      class AbstractRule
        def initialize(actions = [])
          actions = [actions] unless actions.is_a? Array
          @actions = actions.collect { |a| a.to_s }
        end
        def protect? action
          raise NotImplementedError
        end
      end 
      class All < AbstractRule
        def protect? action
          return true
        end
      end
      class Only < AbstractRule
        def protect? action
          return @actions.include?(action.to_s)
        end
      end
      class Except < AbstractRule
        def protect? action
          return !@actions.include?(action.to_s)
        end
      end
    end
    
    class Protector
      @@protectors = {}
      def self.[](name)
        return @@protectors[name]
      end
      def self.[]=(name, protector)
        @@protectors[name] = protector
      end      
      def initialize(action_access_rule, object_names = [])
        @action_access_rule = action_access_rule
        object_names = [object_names] unless object_names.is_a? Array
        @object_names = object_names
      end
      def protect? controller
        return @action_access_rule.protect?(controller.action_name)
      end
      def needs_login? controller
        return controller.session[:user].nil? && @action_access_rule.protect?(controller.action_name)
      end
      def permission_granted? controller
        current_user_id = controller.session[:user]
        return false if current_user_id.nil?
        @object_names.each do |name|
          o = controller.instance_variable_get "@#{name.to_s}".to_sym
          unless o.nil?
            return false unless o.user_id == current_user_id
          end
        end
        return true
      end
    end

    module ClassMethods

      def protect(*args)
        action_access_rule = nil
        object_names = []
        args.each do |a|
          if a == :all
            raise_more_than_one_action_access_rule if action_access_rule
            action_access_rule = ActionAccessRules::All.new
          elsif a.is_a?(Array) || a.is_a?(Symbol)
            raise_more_than_one_action_access_rule if action_access_rule
            action_access_rule = ActionAccessRules::Only.new a
          elsif a.is_a? Hash
            a.each_pair do |key,value|
              key = key.to_sym
              case key
              when :except
                raise_more_than_one_action_access_rule if action_access_rule              
                action_access_rule = ActionAccessRules::Except.new value
              when :only
                raise_more_than_one_action_access_rule if action_access_rule              
                action_access_rule = ActionAccessRules::Only.new value
              when :object
                object_names << value.to_sym                
              when :objects
                value = [value] unless value.is_a? Array
                object_names += value
              else
                raise ArgumentError, "Invalid key: #{key}"
              end
            end
          else
            raise ArgumentError, "Invalid argument to #protect: #{a.inspect}"
          end
        end
        Protector[controller_name] = Protector.new action_access_rule, object_names
        before_filter :check_access
      end

      private 
      
      def raise_more_than_one_action_access_rule
        raise RuntimeError, "More than one action access rule"
      end
      
    end
  
    def check_access
      return unless protector = Protector[controller_name]
      if protector.protect? self
        if protector.needs_login? self
          redirect_to login_url(:request_uri => request.request_uri)
          return false
        elsif !protector.permission_granted?(self)
          raise SecurityError, "Permission denied"
        end
      end
    end
  
    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end