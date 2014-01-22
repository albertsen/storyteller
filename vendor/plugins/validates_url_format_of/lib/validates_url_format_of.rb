module ActiveRecord
  module Validations
    module ClassMethods
      def validates_url_format_of(*attr_names)
      
        configuration = { :message => " does not appear to be a valid URL", 
                          :on => :save }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
        validates_each(attr_names, configuration) do |record, attr_name, value|
          record.errors.add(attr_name, configuration[:message]) unless valid_url?(value)
        end
      end
      
      private
      
      def valid_url?(url)
        begin
          uri = URI.parse(url)
          return uri.class == URI::HTTP
        rescue URI::InvalidURIError
          return false
        end
      end
  
    end   
  end
end
