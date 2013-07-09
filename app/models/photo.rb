class Photo < ActiveRecord::Base
  attr_accessible :name, :width, :height, :orientation
  
  validates :name, :presence => true
  
  has_and_belongs_to_many :tags, :join_table => 'photo_tags'
  has_many :facelocations
  has_many :people, :through => :facelocations
  belongs_to :albums

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
