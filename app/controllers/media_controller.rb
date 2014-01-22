class MediaController < ApplicationController

  protect :all

  def index
    search = params[:search]
    if search
      puts "*** Searching"
      search = "#{search}*"
      @media = Medium.search search
    else
      @media = Medium.find_all
    end
    @upload = Upload.new
  end
  
  def search
  end
  
  def upload
    file = params[:file]
    if file
      filename = File.basename file.original_filename
      media = Medium.find_by_filename(filename) || Medium.new(:filename => filename)
      media.open_io("w+") { |io| io << file.read }
      media.save!
    end
    redirect_to params[:redirect_uri]
  end
  
  def destroy
    Medium.destroy params[:id]
    redirect_to params[:redirect_uri]
  end
  
end