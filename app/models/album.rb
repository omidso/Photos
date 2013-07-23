class Album < ActiveRecord::Base
  attr_accessible :name, :description, :authkey, :onlinename, :foldername, :albumdate, :url, :urlwidth, :urlheight, :albumdatestr
  
  validates :name, :presence => true
  validates :authkey, :presence => true
  validates :onlinename, :presence => true
  validates :foldername, :presence => true 
  validates :albumdate, :presence => true
  validates :url, :presence => true
  validates :urlwidth, :presence => true
  validates :urlheight, :presence => true
  validates :albumdatestr, :presence => true
   
  has_many :photos
    
end
