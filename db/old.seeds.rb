# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'pathname'
require 'exifr'

# globals
gInstructionsFile = 'z:/data/pictures/instructions.csv'
gPictureLocation = 'z:/data/pictures'
gOnlineDataFile = 'picasa.online.csv'
gAlbumDataFile = 'z:/data/pictures/picasa.online.albums.csv'
gFacesFile = 'z:/data/pictures/faces.csv'
gCSVAlbumName = 'album name'
gCSVAlbumDate = 'album date'
gCSVAlbumDesc = 'album description'
gCSVOnlineAlbumName = 'online album name'
gCSVAuthKey = 'auth key'
gCSVFolderName = 'folder name'
gCSVPictureFile = 'picture file'
gCSVOriginalPhotoPath = 'original image path'
gCSVPerson = 'person'
gCSVFaceX = 'face x'
gCSVFaceY = 'face y'
gCSVFaceWidth = 'face width'
gCSVFaceHeight = 'face height'
gUpdateAlbums = false
gUpdateFaces = false

# what do we need to regenerate?
CSV.foreach(gInstructionsFile, :headers => true, :col_sep => ",") do |row|
  if (row['Update Albums'].downcase == "yes")
    gUpdateAlbums= true
  end
  
  if (row['Update Faces'].downcase == "yes")
    gUpdateFaces= true
  end
end

if (gUpdateAlbums)
  
  # First delete all data
  Photo.delete_all
  Tag.delete_all
  Album.delete_all

  # start the album data file
  CSV.open(gAlbumDataFile, "wb") do |csv|
    csv << [gCSVOnlineAlbumName, gCSVAuthKey, gCSVFolderName, gCSVPictureFile, gCSVAlbumName, gCSVAlbumDate, gCSVAlbumDesc]
  
    # start iterating looking for directories only
    Dir.foreach(gPictureLocation) do |dirName|
    
      # skip "." & ".."
      if (dirName == "." || dirName == "..")
        next
      end
    
      # build the fullpath and if it's not a directory, skip it
      pFullPath= Pathname.new(gPictureLocation) + dirName
      if (!pFullPath.directory?)
        next
      end
          
      # step into the directory
      Dir.chdir(pFullPath.to_s)
    
      # look for our special data file, this is contain extra info for the online folder
      # if it's not there, we haven't synced to skip it
      pDataFilePath= pFullPath + gOnlineDataFile
      if (!pDataFilePath.exist?)
        next
      end
    
      # read it
      albumName= ""
      albumDesc= ""
      authKey= ""
      onlineAlbumName= ""
      albumDate= ""
      CSV.foreach(pDataFilePath.to_s, :headers => true, :col_sep => ",") do |row|
      
        # get the info for the album
        onlineAlbumName= row[gCSVOnlineAlbumName]
        authKey= row[gCSVAuthKey]
        albumName= row[gCSVAlbumName]
        albumDate= row[gCSVAlbumDate]
        albumDesc= row[gCSVAlbumDesc]
      
        # break, we only care about the first line and ignore others
        break
      end
    
      # now get all the filenames & write them to the csv file   
      Dir.glob("*.jpg") do |fName|
        csv << [onlineAlbumName, authKey, dirName, fName, albumName, albumDate, albumDesc]
      end
      
    end # Dir.foreach(gPictureLocation) do |dirName|
    
  end # CSV.open(gAlbumDataFile, "wb") do |csv|
  
  # open the album file and start going through it
  CSV.foreach(gAlbumDataFile, :headers => true, :col_sep => ",") do |row|
    
    # find or create the album
    album= Album.where(:foldername => row[gCSVFolderName]).first_or_create(:onlinename => row[gCSVOnlineAlbumName], 
                                                                           :authkey => row[gCSVAuthKey],
                                                                           :name => row[gCSVAlbumName],
                                                                           :albumdate => row[gCSVAlbumDate],
                                                                           :description => row[gCSVAlbumDesc])
    # build the full path to the picture file & get info
    p= Pathname(gPictureLocation)
    p+= row[gCSVFolderName]
    p+= row[gCSVPictureFile]
    pf= EXIFR::JPEG.new(p.to_s)
    
    orientation= 0;
    if pf.orientation == EXIFR::TIFF::TopLeftOrientation 
      orientation= 1;
    elsif pf.orientation ==EXIFR::TIFF::RightTopOrientation     
      orientation= 2;
    elsif pf.orientation ==EXIFR::TIFF::BottomRightOrientation
      orientation= 3;
    elsif pf.orientation ==EXIFR::TIFF::LeftBottomOrientation
      orientation= 4;
    else 
      orientation= 1;
    end
      
    # create the photo & associate with the album
    photo= Photo.create(name: row[gCSVPictureFile], width: pf.width, height: pf.height, orientation: orientation)
    album.photos << photo
  end
end

if (gUpdateAlbums || gUpdateFaces)
  
  Person.delete_all
  Facelocation.delete_all

  # Now read the faces file and create associations
  CSV.foreach(gFacesFile, :headers => true, :col_sep => ";") do |row|
    
    # find or create the person
    person= Person.where(:name => row[gCSVPerson]).first_or_create()
    
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
end