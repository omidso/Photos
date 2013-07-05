# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'pathname'

# First delete all data
Person.delete_all
Photo.delete_all
Tag.delete_all
Facelocation.delete_all
Album.delete_all

# globals
gAlbumDataFile = 'z:/data/pictures/picasa.online.albums.csv'
gFacesFile = 'z:/data/pictures/faces.csv'
gCSVAlbumNameColumn = 'online album name'
gCSVAuthKeyColumn = 'auth key'
gCSVFolderNameColumn = 'folder name'
gCSVPictureFileColumn = 'picture file'
gCSVOriginalPhotoPath = 'original image path'
gCSVPersonColumn = 'person'
gCSVFaceX = 'face x'
gCSVFaceY = 'face y'
gCSVFaceWidth = 'face width'
gCSVFaceHeight = 'face height'

# open the album file and start going through it
CSV.foreach(gAlbumDataFile, :headers => true, :col_sep => ",") do |row|
  
  # find or create the album
  album= Album.where(:foldername => row[gCSVFolderNameColumn]).first_or_create(:name => row[gCSVAlbumNameColumn], 
                                                                               :authkey => row[gCSVAuthKeyColumn])
  
  # create the photo & associate with the album
  photo= Photo.create(name: row[gCSVPictureFileColumn])
  album.photos << photo
end

# Now read the faces file and create associations
CSV.foreach(gFacesFile, :headers => true, :col_sep => ";") do |row|
  
  # find or create the person
  person= Person.where(:name => row[gCSVPersonColumn]).first_or_create()
  
  # get the full path as a path after converting slashes
  fullPicturePath= Pathname(row[gCSVOriginalPhotoPath].gsub('\\', '/'))
  
  # get the picture name
  pictureName= fullPicturePath.basename.to_s; 
  
  # get the folder name
  folderName= fullPicturePath.dirname.basename.to_s;
  
  # find the album
  album= Album.where(:foldername => folderName).first
  
  # found?
  if (album)
    
    # look for the picture
    photo= album.photos.where(:name => pictureName).first
    
    # found ?
    if (photo)
      
      # create the facelocation
      fl= photo.facelocations.create(:xloc => row[gCSVFaceX],
                                     :yloc => row[gCSVFaceY],
                                     :width => row[gCSVFaceWidth],
                                     :height => row[gCSVFaceHeight])
      person.facelocations << fl
      
    end # if (photo)
  
  end # if (album)
  
end # CSV.foreach(gFacesFile, :headers => true, :col_sep => ";") do |row|