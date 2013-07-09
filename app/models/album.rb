class Album < ActiveRecord::Base
  attr_accessible :name, :description, :authkey, :onlinename, :foldername, :albumdate
  
  validates :name, :presence => true
  validates :authkey, :presence => true
  validates :onlinename, :presence => true
  validates :foldername, :presence => true 
  validates :albumdate, :presence => true
   
  has_many :photos
    
end
