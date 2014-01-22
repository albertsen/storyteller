class User < ActiveRecord::Base

  has_many :stories

  def self.try_to_authenticate(username, password)
    user = find(:first, :conditions => ['username = ?', username])
    if !user.nil? && (hash_password(password, user.password_salt) == user.password_hash)
      return user
    else
      return nil
    end
  end

  def self.generate_salt
    return [Array.new(6){rand(256).chr}.join].pack("m").chomp
  end

  def self.hash_password(password, salt)
    return Digest::SHA256.hexdigest(password + salt)
  end

  def logged_in
    self.last_login = Time.now
    self.save!
  end
  
  def remember_me
    if self.auth_token.nil?
      salt = self.class.generate_salt
      update_attributes(:auth_token => Digest::SHA256.hexdigest("#{salt}--#{self.username}--#{Time.now}"))
    end
  end
  
  def forget_me
    update_attributes(:auth_token => nil)
  end  
  
end
