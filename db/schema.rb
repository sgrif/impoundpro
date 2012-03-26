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

ActiveRecord::Schema.define(:version => 20120323164138) do

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
    t.string   "lien_holder_name"
    t.string   "lien_holder_address"
    t.decimal  "charge_mileage",            :precision => 8, :scale => 2
    t.decimal  "charge_storage",            :precision => 8, :scale => 2
    t.decimal  "charge_admin",              :precision => 8, :scale => 2
    t.float    "tax"
    t.decimal  "storage_rate",              :precision => 8, :scale => 2
    t.boolean  "mvd_inquiry_made"
    t.string   "preparers_name"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "color"
    t.integer  "user_id"
    t.string   "owner_city"
    t.string   "owner_state"
    t.string   "owner_zip"
    t.string   "lien_holder_city"
    t.string   "lien_holder_state"
    t.string   "lien_holder_zip"
    t.string   "driver_name"
    t.string   "driver_address"
    t.string   "driver_city"
    t.string   "driver_state"
    t.string   "driver_zip"
    t.decimal  "charge_hook_up",            :precision => 8, :scale => 2
    t.decimal  "charge_other",              :precision => 8, :scale => 2
    t.string   "stripe_invoice_item_token"
    t.boolean  "paid"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "salt"
    t.string   "name"
    t.string   "address"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "county"
    t.string   "phone_number"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "preparers_name"
    t.string   "stripe_customer_token"
    t.boolean  "paid"
  end

end
