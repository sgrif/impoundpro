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

ActiveRecord::Schema.define(:version => 20120810160800) do

  create_table "cars", :force => true do |t|
    t.string   "size"
    t.string   "state"
    t.string   "vin"
    t.string   "license_plate_number"
    t.string   "owner_name"
    t.string   "owner_address"
    t.string   "lien_holder_name"
    t.string   "lien_holder_address"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "color"
    t.string   "owner_city"
    t.string   "owner_state"
    t.string   "owner_zip"
    t.string   "lien_holder_city"
    t.string   "lien_holder_state"
    t.string   "lien_holder_zip"
    t.string   "stripe_invoice_item_token"
    t.boolean  "paid"
    t.string   "invoice_item_id"
    t.integer  "user_id"
    t.integer  "year_id"
    t.integer  "make_id"
    t.integer  "model_id"
    t.integer  "trim_id"
  end

  create_table "makes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.integer  "make_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models_years", :id => false, :force => true do |t|
    t.integer "model_id"
    t.integer "year_id"
  end

  create_table "stripe_webhooks", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "target_id"
  end

  create_table "trims", :force => true do |t|
    t.integer  "model_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "trims_years", :id => false, :force => true do |t|
    t.integer "trim_id"
    t.integer "year_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest",        :limit => 63
    t.string   "name",                   :limit => 63
    t.string   "address",                :limit => 127
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "city",                   :limit => 63
    t.string   "state",                  :limit => 4
    t.string   "zip",                    :limit => 15
    t.string   "county",                 :limit => 31
    t.string   "phone_number",           :limit => 15
    t.string   "auth_token",             :limit => 20
    t.string   "password_reset_token",   :limit => 20
    t.datetime "password_reset_sent_at"
    t.string   "preparers_name",         :limit => 50
    t.string   "stripe_customer_token",  :limit => 20
    t.boolean  "paid"
    t.boolean  "admin",                                 :default => false
    t.integer  "cars_count",                            :default => 0
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["stripe_customer_token"], :name => "index_users_on_stripe_customer_token", :unique => true

  create_table "years", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
