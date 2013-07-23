class Person < ActiveRecord::Base
    attr_accessible :name, :url, :urlheight, :urlwidth
    
    validates :name, :presence => true
   
    has_many :facelocations
    has_many :photos, :through => :facelocations
    
    def self.search(search)
      if search
        where('name LIKE ?', "%#{search}%")
      else
        all
      end
    end
    
end