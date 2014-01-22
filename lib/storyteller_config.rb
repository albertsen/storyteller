class StorytellerConfig
  
  @@default = nil
  
  def self.default
    @@default ||= StorytellerConfig.new
  end
  
  attr_reader :javascript_libs
  
  def initialize
    @javascript_libs = {}
  end
  
end

module Rails
  
  class Configuration  
    def storyteller
      StorytellerConfig.default
    end
  end
  
end