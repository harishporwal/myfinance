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

ActiveRecord::Schema.define(:version => 20130115025713) do

  create_table "stock_watchlists", :force => true do |t|
    t.string   "symbol"
    t.string   "exchange"
    t.string   "classification"
    t.string   "notes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "stock_watchlists", ["classification"], :name => "index_stock_watchlists_on_classification"
  add_index "stock_watchlists", ["symbol"], :name => "index_stock_watchlists_on_symbol", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "tags", ["taggable_type", "taggable_id", "name"], :name => "index_tags_on_taggable_type_and_taggable_id_and_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "watch_parameters", :force => true do |t|
    t.string   "symbol"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.decimal  "ma_50"
    t.decimal  "ma_100"
    t.decimal  "ma_200"
    t.decimal  "resistance"
    t.decimal  "breakout"
    t.decimal  "price"
  end

  add_index "watch_parameters", ["symbol"], :name => "index_watch_parameters_on_symbol"

end
