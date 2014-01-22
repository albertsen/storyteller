module ApplicationHelper

  include UrlHelper
  include Security::SecurityHelper
  
  def validation_errors_for(object, message = nil)
    render :partial => "partials/validation_errors", :locals => {:object => object, :message => message}
  end
  
  def javascript_lib_includes(*libs)
    libs.inject([]) do |includes,l|
      files = config.javascript_libs[l.to_sym]
      files = ["#{l}.js"] if files.blank?
      files = [files] unless files.is_a?(Array)
      files.each do |f|
        if File.exist?("#{RAILS_ROOT}/public/javascripts/#{f}")
          includes << %Q{<script type="text/javascript" src="/javascripts/#{f}"></script>}
        end
      end
      includes
    end.join("\n")
  end
  
  protected
  
  def config
    StorytellerConfig.default
  end
  
end