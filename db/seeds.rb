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
gHeadshotAlbumName = 'Headshots'
gHeadshotAuthKey = 'Gv1sRgCM2sh8fw47KmnwE'
gInstructionsFile = 'z:/data/pictures/instructions.csv'
gPictureLocation = 'z:/data/pictures'
gAlbumDataFile = 'z:/data/pictures/picasa.online.txt'
gFacesFile = 'z:/data/pictures/faces.csv'
gCSVAlbumName = 'album name'
gCSVAlbumDate = 'album date'
gCSVAlbumDesc = 'album description'
gCSVOnlineAlbumName = 'online album name'
gCSVAuthKey = 'auth key'
gCSVFolderName = 'folder name'
gCSVOriginalPhotoPath = 'original image path'
gCSVPerson = 'person'
gCSVFaceX = 'face x'
gCSVFaceY = 'face y'
gCSVFaceWidth = 'face width'
gCSVFaceHeight = 'face height'
gUpdateAlbums = false
gUpdateFaces = false
gUserId = "omid.sojoodi"
gNoHeadshot = "nopic"


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

  # open the album file
  CSV.foreach(gAlbumDataFile, :headers => true, :col_sep => "\t") do |row|
    
    # get the info for the album
    onlineAlbumName= row[gCSVOnlineAlbumName]
    localFolder= row[gCSVFolderName].downcase
    authKey= row[gCSVAuthKey]
    albumName= row[gCSVAlbumName]
    albumDate= row[gCSVAlbumDate]
    albumDesc= row[gCSVAlbumDesc]
    
    # query it online
    mainURL = "https://picasaweb.google.com/data/feed/api/user/#{gUserId}/album/#{onlineAlbumName}?&kind=photo&access=private&authkey=#{authKey}&max-results=500&thumbsize=104u,400u,1200u,1600u&alt=json"
    url= URI.parse(URI.encode(mainURL))
    response= Net::HTTP.start(url.host, use_ssl: true, verify_mode:OpenSSL::SSL::VERIFY_NONE) do |http|
      http.get url.request_uri
    end
    
    # make sure it worked
    case response
      when Net::HTTPRedirection
      when Net::HTTPSuccess then
        outputData= JSON.parse response.body
      else
        break
    end
      
    # get the date in a format we'll print
    parts= albumDate.split('-')
    t= Time.new(parts[2], parts[0], parts[1])
    datestr= t.strftime("%B %-d, %Y")
    
    #puts 'Read: "' +
    #  localFolder + '" ' + 
    #  onlineAlbumName + " " +
    #  authKey + " " +
    #  albumName + " " +
    #  albumDate + " " +
    #  datestr + " " + 
    #  albumDesc + " " +
    #  outputData['feed']['entry'][0]['media$group']['media$thumbnail'][1]['url'] + " " +
    #  outputData['feed']['entry'][0]['media$group']['media$thumbnail'][1]['width'].to_s + " " +
    #  outputData['feed']['entry'][0]['media$group']['media$thumbnail'][1]['height'].to_s
    
    # find or create the album
    album= Album.where(:foldername => localFolder).first_or_create(:onlinename => onlineAlbumName,
                                                                   :foldername => localFolder,
                                                                   :authkey => authKey,
                                                                   :name => albumName,
                                                                   :albumdate => t,
                                                                   :albumdatestr => datestr,
                                                                   :description => albumDesc,
                                                                   :url => outputData['feed']['entry'][0]['media$group']['media$thumbnail'][1]['url'],
                                                                   :urlwidth => outputData['feed']['entry'][0]['media$group']['media$thumbnail'][1]['width'],
                                                                   :urlheight => outputData['feed']['entry'][0]['media$group']['media$thumbnail'][1]['height'])
    if (album.id == nil)
      puts "ERROR!"
      break;
    end
                                                                               
    # build path to the folder & go there
    pFullPath= Pathname.new(gPictureLocation) + localFolder;
    if (!pFullPath.exist?)
      puts "ERROR: Can't find local album: " + localFolder + " " + onlineAlbumName
    end
    Dir.chdir(pFullPath.to_s)

    # start going through the .jpg files in this directory
    outputData['feed']['entry'].each do |entry|
      pName= entry['title']['$t']
      pId= entry['gphoto$id']['$t']
      
      # file exists locally?
      pPath= Pathname.new(pName)
      if (!pPath.exist?)
        puts "DELETE: " + pFullPath.to_s + "/" + pName
        next
      end
      
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
          url: entry['media$group']['media$thumbnail'][2]['url'],
          largeurl: entry['media$group']['media$thumbnail'][3]['url'], 
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
    puts localFolder + " Total: " + Photo.count.to_s
  end
end

if (gUpdateAlbums || gUpdateFaces)
  
  Person.delete_all
  Facelocation.delete_all
  
  # query the headshots folder
  mainURL = "https://picasaweb.google.com/data/feed/api/user/#{gUserId}/album/#{gHeadshotAlbumName}?&kind=photo&access=private&authkey=#{gHeadshotAuthKey}&max-results=500&thumbsize=288u&alt=json"
  url= URI.parse(URI.encode(mainURL))
  response= Net::HTTP.start(url.host, use_ssl: true, verify_mode:OpenSSL::SSL::VERIFY_NONE) do |http|
    http.get url.request_uri
  end
    
  # make sure it worked
  case response
    when Net::HTTPRedirection
    when Net::HTTPSuccess then
      outputData= JSON.parse response.body
    else
      puts "ERROR getting headshots!"
      exit
  end
  
  # store in a hash so we can get them easily
  urlList= Hash.new
  outputData['feed']['entry'].each do |entry|
    
    # photo name is the person's name
    pName= entry['title']['$t']
    
    # strip off extension & downcase
    pName= pName.split('.')[0].downcase
    
    puts "Found headshot: " + pName
    
    # store url
    urlList[pName] = {url: entry['media$group']['media$thumbnail'][0]['url'],
                      width: entry['media$group']['media$thumbnail'][0]['width'],
                      height: entry['media$group']['media$thumbnail'][0]['height']};
  end

  # Now read the faces file and create associations
  CSV.foreach(gFacesFile, :headers => true, :col_sep => ";") do |row|
    
    # see if we have a url
    pUrl= urlList[row[gCSVPerson].downcase]
    if (!pUrl) 
      pUrl= urlList[gNoHeadshot];
    end
    person= Person.where(:name => row[gCSVPerson]).first_or_create(:url => pUrl[:url], :urlwidth => pUrl[:width], :urlheight => pUrl[:height])
    
    # get the full path as a path after converting slashes
    fullPicturePath= Pathname(row[gCSVOriginalPhotoPath].gsub('\\', '/'))
    
    # get the picture name
    pictureName= fullPicturePath.basename.to_s; 
    
    # get the folder name
    folderName= fullPicturePath.dirname.basename.to_s.downcase;
    
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
      else
        puts "Found album but no photo: " + pictureName + " " + folderName
      end
    else
      if (folderName == "2012-10-20 Caroline And Doug's Wedding")
        puts "Can't find the album"
      end
    end
  end
end