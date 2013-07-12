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
require 'rubygems'
require 'cgi'
require 'net/https'
require 'net/http'
require 'xmlsimple'
require 'JSON'

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
gUserId = "omid.sojoodi"


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
      
    # find or create the album
    album= Album.where(:foldername => pFullPath.basename.to_s).first_or_create(:onlinename => onlineAlbumName,
                                                                               :authkey => authKey,
                                                                               :name => albumName,
                                                                               :albumdate => albumDate,
                                                                               :description => albumDesc)
    # start a query get all the files in the 
    mainURL = "https://picasaweb.google.com/data/feed/api/user/#{gUserId}/album/#{onlineAlbumName}?&kind=photo&access=private&authkey=#{authKey}&max-results=500&thumbsize=104u,1200u,1600u&alt=json"
    url= URI.parse(URI.encode(mainURL))
    response= Net::HTTP.start(url.host, use_ssl: true, verify_mode: 
    OpenSSL::SSL::VERIFY_NONE) do |http|
      http.get url.request_uri
    end

    case response
      when Net::HTTPRedirection
      when Net::HTTPSuccess then 
        outputData = JSON.parse response.body
      else
      # response code isn't a 200; raise an exception
        puts "error"
        exit
      end

    # start going through the .jpg files in this directory
    #Dir.glob("*.jpg") do |fName|
    outputData['feed']['entry'].each do |entry|
      pName= entry['title']['$t']
      pId= entry['gphoto$id']['$t']
      
      # find file locally
      orientation= 0;
      pf= EXIFR::JPEG.new(pName)
      if (pf)
        case pf.orientation
          when EXIFR::TIFF::TopLeftOrientation then orientation= 1
          when EXIFR::TIFF::RightTopOrientation then orientation= 2;
          when EXIFR::TIFF::BottomRightOrientation then orientation= 3;
          when EXIFR::TIFF::LeftBottomOrientation then orientation= 4;
          else orientation= 1;
        end
        
        # create the photo & associate with the album
        photo= Photo.create(name: pName, onlineid: pId, width: pf.width, height: pf.height, orientation: orientation,
          thumburl: entry['media$group']['media$thumbnail'][0]['url'], 
          url: entry['media$group']['media$thumbnail'][1]['url'],
          largeurl: entry['media$group']['media$thumbnail'][2]['url'], 
          focallength: (entry['exif$tags']['exif$focallength'] ? entry['exif$tags']['exif$focallength']['$t'] : "?"), 
          fstop: (entry['exif$tags']['exif$fstop'] ? entry['exif$tags']['exif$fstop']['$t'] : "?"),
          exposure: (entry['exif$tags']['exif$exposure'] ? entry['exif$tags']['exif$exposure']['$t'] : "?"), 
          iso: (entry['exif$tags']['exif$iso'] ? entry['exif$tags']['exif$iso']['$t'] : "?"),
          flash: (entry['exif$tags']['exif$flash'] ? (entry['exif$tags']['exif$flash']['$t'] == "true" ? "on" : "off") : "?"),
          make: (entry['exif$tags']['exif$make'] ? entry['exif$tags']['exif$make']['$t'] : "?"), 
          model: (entry['exif$tags']['exif$model'] ? entry['exif$tags']['exif$model']['$t'] : "?"),
          time: pf.date_time)
        album.photos << photo
      end
    end
    puts Photo.count
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