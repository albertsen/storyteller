class Module
  
  def self.for_name(name)
    Kernel.const_get(name)
  end
  
end