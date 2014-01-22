class ActiveForm
  
  include Validatable  

  def initialize(attributes = {})
    attributes.each do |k,v|
      self.send "#{k}=".to_sym, v
    end unless attributes.blank?
  end

end