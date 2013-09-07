class PhotosController < ApplicationController
  
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo= Photo.find(params[:id])
    id= params[:id].to_i
    @piclist= get_cur_piclist
    index= @piclist.index {
      |x| x.id==id
    }
    if (index>0)
      @prev= index-1
    else
      @prev= @piclist.length-1
    end
    if (index<(@piclist.length-1))
      @next= index+1
    else
      @next= 0
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end
  
  # GET /photos/1/tags
  # GET /photos/1.json/tags
  def tags
    @photo= Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end
  
  # GET /photos/1/people
  # GET /photos/1.json/people
  def people
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end
  
  # GET /photo/people.json
  def photo_people
    p= params[:q].split(":")
    album= Album.find(p[0])
    photo= album.photos.find(p[1])
    
    respond_to do |format|
      format.json {render :json => {:width => photo.width, :height => photo.height, :orientation => photo.orientation, :people => photo.people, :faces => photo.facelocations}}
    end
  end
  
=begin
  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end
=end

end
