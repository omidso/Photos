class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_site_stats 
  
  private
  
  @@global_piclist = []
  @@global_index = 0
  
  def load_site_stats 
    @stats= Hash.new
    @stats['albums']= Album.count
    @stats['photos']= Photo.count
    
    newest= Album.order('created_at DESC').limit(1).first.created_at.to_datetime
    datestr= newest.month.to_s + "/" + newest.day.to_s + "/" + newest.year.to_s
    @stats['updated']= datestr
  end
  
  def set_cur_piclist(p, i)
    @@global_piclist= p
    @@global_index= i
  end
  
  def get_cur_piclist
    return @@global_piclist
  end
  
  def get_cur_index
    return @@global_index
  end

end
