class Upload < ActiveForm
  
  attr_accessor :file
  
  validates_presence_of :file, :message => "File missing"

end