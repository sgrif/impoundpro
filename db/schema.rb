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

ActiveRecord::Schema.define(:version => 20120227172957) do

  create_table "cars", :force => true do |t|
    t.integer  "year"
    t.string   "make"
    t.string   "model"
    t.string   "size"
    t.string   "state"
    t.string   "vin"
    t.string   "license_plate_number"
    t.datetime "date_towed"
    t.string   "tow_requested_by"
    t.string   "tow_reason"
    t.datetime "mail_notice_of_lien_date"
    t.string   "owner_name"
    t.string   "owner_address"
    t.string   "owner_city_state_zip"
    t.string   "lien_holder_name"
    t.string   "lien_holder_address"
    t.string   "lien_holder_city_state_zip"
    t.decimal  "charge_towing",              :precision => 8, :scale => 2
    t.decimal  "charge_storage",             :precision => 8, :scale => 2
    t.decimal  "charge_admin",               :precision => 8, :scale => 2
    t.float    "tax"
    t.decimal  "storage_rate",               :precision => 8, :scale => 2
    t.boolean  "mvd_inquiry_made"
    t.string   "preparers_name"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.boolean  "has_registered_owner"
    t.boolean  "has_lien_holder"
    t.boolean  "has_charges"
    t.string   "color"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "name"
    t.string   "address"
    t.string   "city_state_zip"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
