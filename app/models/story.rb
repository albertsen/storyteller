class Story < Item
  
  validates_presence_of :body, :message => "Body must not be empty"
  
end