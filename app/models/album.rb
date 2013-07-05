class Album < ActiveRecord::Base
  attr_accessible :authkey, :name, :foldername
  
  validates :authkey, :presence => true
  validates :name, :presence => true
  validates :foldername, :presence => true 
   
  has_many :photos
    
end
