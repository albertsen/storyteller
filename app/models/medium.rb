class Medium < ActiveRecord::Base

  validates_presence_of :filename, :message => "File name missing"
  after_destroy :delete_file

  def self.find_all(options = {})
    options = {:order => "updated_at DESC"}.merge options
    find :all, options
  end
  
  def self.search(expression)
    expression.gsub! /\*/, "%"
    expression.gsub! /\?/, "_"
    find_all :conditions => ["filename LIKE ?", expression]
  end

  def url_path
    "/media/#{filename}"
  end

  def full_path
    "#{RAILS_ROOT}/public/media/#{filename}"
  end
  
  def open_io(mode, &block)
    raise ArgumentError "No block given" unless block_given?
    path = self.full_path
    FileUtils.mkdir_p File.dirname(path)
    File.open(path, mode) do |io|
      yield io
    end
  end
  
  protected 
  
  def delete_file
    File.delete full_path
  end
  
end
