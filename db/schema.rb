# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130615011301) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "onlinename"
    t.string   "authkey"
    t.string   "foldername"
    t.integer  "urlwidth"
    t.integer  "urlheight"
    t.string   "url"
    t.string   "albumdatestr"
    t.datetime "albumdate"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "facelocations", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "person_id"
    t.integer  "xloc"
    t.integer  "yloc"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people", :force => true do |t|
    t.string  "name",      :null => false
    t.string  "url"
    t.integer "urlheight"
    t.integer "urlwidth"
  end

  create_table "photo_tags", :force => true do |t|
    t.integer "photo_id"
    t.integer "tag_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "onlineid",    :null => false
    t.integer  "width"
    t.integer  "height"
    t.integer  "orientation"
    t.string   "focallength"
    t.string   "fstop"
    t.string   "iso"
    t.string   "exposure"
    t.string   "flash"
    t.string   "make"
    t.string   "model"
    t.string   "thumburl"
    t.string   "url"
    t.string   "largeurl"
    t.datetime "time"
    t.integer  "album_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tags", :force => true do |t|
    t.string "name", :null => false
  end

end
