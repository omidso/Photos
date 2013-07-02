# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'Z:/RailsInstaller/Ruby1.9.3/lib/ruby/gems/1.9.1/gems/exifr-1.1.3/lib/exifr.rb'
require 'csv'

# First delete all data
Person.delete_all
Photo.delete_all
Tag.delete_all
Facelocation.delete_all

# globals
gPictureLocation = 'z:\Omid\Aptana Studio 3 Workspace\Photos\app\assets\images'
gFacesFile = 'faces.csv'

# goto the picture location
Dir.chdir(gPictureLocation)

# TODO: some pictures don't have the date and all the timezones are off
# Nextstep: stome picture not getting created, unknown why (maybe because of dates missing), look for 0105A-11.jpg in folder 2000
Dir.glob("**/*.jpg") do |picture_file| # note one extra "*"
  
  # get the EXIFR info
  extInfo= EXIFR::JPEG.new(picture_file)
  
  # make sure there is a creation date (not all pictures have them)
  createTime= extInfo.date_time_original
  
  # if no creation date, use the file creation time
  if (createTime == nil)
    createTime= Pathname.new(picture_file).ctime
  end
  
  # finally, insert the picture info into the database
  Photo.create(path: picture_file,
               width: extInfo.width, 
               height: extInfo.height, 
               date: createTime)
end

# Now read the faces file and create associations
CSV.foreach(gFacesFile, :headers => true, :col_sep => ";") do |row|
  
  # get the directory name as a string after converting slashes
  sPath= row['original image path'].gsub('\\', '/')

  # find or create the person
  person= Person.where(:name => row['person']).first_or_create()
  
  # find the photo
  photo= Photo.where(:path=> sPath).first

  # if the photo is found, create the association
  if (photo)
    fl= photo.facelocations.create(:xloc => row['face x'],
                                   :yloc => row['face y'],
                                   :width => row['face width'],
                                   :height => row['face height'])
    person.facelocations << fl
  end
end
