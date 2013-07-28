class AlbumsController < ApplicationController
  
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.order("albumdate DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end
  
  def album_photos
    album = Album.find(params[:id])
    
    respond_to do |format|
      format.json { render json: album.photos}
    end
  end

  def album_recent
    albums = Album.order("created_at DESC").limit(6)
    
    respond_to do |format|
      format.json { render json: albums}
    end
  end
  
end
