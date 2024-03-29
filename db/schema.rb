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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141024112243) do

  create_table "people", force: true do |t|
    t.string   "name",                 limit: 255
    t.string   "avatar_uid",           limit: 255
    t.string   "occupation",           limit: 255
    t.integer  "salary",               limit: 4
    t.float    "stock_options",        limit: 24
    t.date     "hired_on"
    t.date     "fired_on"
    t.text     "previous_occupations", limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

end
