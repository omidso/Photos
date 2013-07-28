class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_site_stats 
  
  private
  
  def load_site_stats 
    @stats= Hash.new
    @stats['albums']= Album.count
    @stats['photos']= Photo.count
    
    newest= Album.order('created_at DESC').limit(1).first.created_at.to_datetime
    datestr= newest.month.to_s + "/" + newest.day.to_s + "/" + newest.year.to_s
    @stats['updated']= datestr
  end

end
