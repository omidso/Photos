class Photo < ActiveRecord::Base
  attr_accessible :path, :width, :height, :date
  
  validates :path,    :presence => true
  validates :width,   :numericality => {:greater_than => 0}
  validates :height,  :numericality => {:greater_than => 0}
  validates :date,    :presence => true 
  
  has_and_belongs_to_many :tags, :join_table => 'photo_tags'
  has_many :facelocations
  has_many :people, :through => :facelocations

  def names_sorted_string
    names= ""
    self.people.each do |person|
      if names==""
        names= person.name
      else 
        names += ", " + person.name
      end
    end
    return names
  end
    
end
