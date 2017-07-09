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

ActiveRecord::Schema.define(version: 20160829101233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_points", force: :cascade do |t|
    t.integer "answer_id"
    t.integer "spe_id"
    t.integer "score",     default: 0
  end

  add_index "answer_points", ["answer_id"], name: "index_answer_points_on_answer_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "answer_number"
    t.string  "answer"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_vars", force: :cascade do |t|
    t.string "name"
    t.string "value"
  end

  create_table "connection_logs", force: :cascade do |t|
    t.integer  "spe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: :cascade do |t|
    t.boolean  "reversible",  default: false
    t.string   "description"
    t.string   "blob"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: :cascade do |t|
    t.string   "question"
    t.integer  "vote_count", default: 0
    t.float    "coeff",      default: 0.0
    t.boolean  "multiple",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spes", force: :cascade do |t|
    t.string  "username"
    t.string  "full_name"
    t.string  "key"
    t.boolean "elligible",   default: true
    t.string  "admin_token"
  end

  create_table "suggested_coeffs", force: :cascade do |t|
    t.integer "question_id"
    t.integer "spe_id"
    t.integer "coeff",       default: 0
  end

  add_index "suggested_coeffs", ["question_id"], name: "index_suggested_coeffs_on_question_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "phonenumber"
    t.date    "birthday"
    t.string  "gender"
    t.string  "token"
    t.integer "godfather_id"
  end

  create_table "users_answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "answer_number"
    t.integer "user_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "question_id"
    t.integer "spe_id"
    t.integer "vote",        default: 0
  end

  add_index "votes", ["question_id"], name: "index_votes_on_question_id", using: :btree

end
