class LoginCredentials < ActiveForm
    
  attr_accessor :username, :password, :remember_me
  
  validates_presence_of :username, :message => "Username must not be empty"
  validates_presence_of :password, :message => "Password must not be empty"

  def remember_me?
    @remember_me
  end

end