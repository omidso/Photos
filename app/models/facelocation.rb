class Facelocation < ActiveRecord::Base
  attr_accessible :xloc, :yloc, :width, :height
  
  validates :xloc,  :numericality => {:greater_than => 0}
  validates :yloc,  :numericality => {:greater_than => 0}
  validates :width, :numericality => {:greater_than => 0}
  validates :height,:numericality => {:greater_than => 0}
  
  belongs_to :photo
  belongs_to :person
end