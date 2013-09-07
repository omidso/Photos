class PeopleController < ApplicationController
  
  # include helper methods from application_helper.rb
  helper ApplicationHelper

  # GET /people
  # GET /people.json
  def index
    # for simple search
    # @people= Person.search(params[:search])
    
    if (params[:q])
      @people= Person.search(params[:q])
    else
      @people= Person.order("name ASC")
    end
        
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/photos
  # GET /people/1.json/photos
  def photos
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person.photos }
    end
  end
  
  def person_photos
    person= Person.find(params[:id])
    piclist= person.photos.order('time DESC')
    set_cur_piclist(piclist, 0)
    
    if person
      respond_to do |format|
        format.json {render :json => piclist }
      end
    end
  end

  def photo_by_count
    people= Person.all
    
    a= Array.new(people.count, Hash.new)
    i= 0;
    people.each do |person|
      a[i]= {:count => person.photos.count, :person => person}
      i+= 1
    end
    a.sort_by!{ |h| h[:count]}.reverse!
    
    respond_to do |format|
      format.json {render json: a}
    end
  end
  
  def photo_by_name
    people= Person.order("name ASC")
    
    a= Array.new(people.count, Hash.new)
    i= 0;
    people.each do |person|
      a[i]= {:count => person.photos.count, :person => person}
      i+= 1
    end
    
    respond_to do |format|
      format.json {render json: a}
    end
  end

=begin
  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render json: @person, status: :created, location: @person }
      else
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end
=end
  
end
