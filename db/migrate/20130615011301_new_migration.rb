class NewMigration < ActiveRecord::Migration
  def change
    create_table(:photos) do |t|
      t.column :path,   :string, :null => false
      t.column :width,  :integer
      t.column :height, :integer
      t.column :date,   :timestamp
    end
    
    create_table(:tags) do |t|
      t.column :name, :string, :null =>false
    end
    
    create_table(:people) do |t|
      t.column :name, :string, :null => false
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
    end
  end
end
