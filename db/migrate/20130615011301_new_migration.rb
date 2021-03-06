class NewMigration < ActiveRecord::Migration
  def change
    
    create_table :albums do |t|
      t.string :name
      t.string :description
      t.string :onlinename
      t.string :authkey
      t.string :foldername
      t.integer :urlwidth
      t.integer :urlheight
      t.string :url      
      t.string :albumdatestr
      t.datetime :albumdate

      t.timestamps
    end

    create_table(:photos) do |t|
      t.string :name, :null => false
      t.string :onlineid, :null => false
      t.integer :width
      t.integer :height
      t.integer :orientation
      t.string :focallength
      t.string :fstop
      t.string :iso
      t.string :exposure
      t.string :flash
      t.string :make
      t.string :model
      t.string :thumburl
      t.string :url
      t.string :largeurl
      t.datetime :time
      t.belongs_to :album
      
      t.timestamps
    end
    
    create_table(:tags) do |t|
      t.column :name, :string, :null =>false
    end
    
    create_table(:people) do |t|
      t.column :name, :string, :null => false
      t.string :url
      t.integer :urlheight
      t.integer :urlwidth
    end

    create_table(:photo_tags) do |t|
      t.integer :photo_id
      t.integer :tag_id
    end
    
    create_table(:facelocations) do |t|
      t.column  :photo_id, :integer
      t.column  :person_id, :integer
      t.column  :xloc,  :integer
      t.column  :yloc,  :integer
      t.column  :width, :integer
      t.column  :height,:integer
      
      t.timestamps
    end
    
  end
end
