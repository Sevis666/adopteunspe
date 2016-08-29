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

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "answer_number"
    t.string  "answer"
    t.integer "abecassis",     default: 0
    t.integer "athor",         default: 0
    t.integer "azizian",       default: 0
    t.integer "beaulieu",      default: 0
    t.integer "boutin",        default: 0
    t.integer "bruneaux",      default: 0
    t.integer "brunod",        default: 0
    t.integer "bustillo",      default: 0
    t.integer "careil",        default: 0
    t.integer "chardon",       default: 0
    t.integer "cortes",        default: 0
    t.integer "diridollou",    default: 0
    t.integer "dumond",        default: 0
    t.integer "fievet",        default: 0
    t.integer "flechelles",    default: 0
    t.integer "gaborit",       default: 0
    t.integer "georges",       default: 0
    t.integer "godefroy",      default: 0
    t.integer "haas",          default: 0
    t.integer "khalfallah",    default: 0
    t.integer "lanfranchi",    default: 0
    t.integer "lecat",         default: 0
    t.integer "ledaguenel",    default: 0
    t.integer "laigret",       default: 0
    t.integer "lengele",       default: 0
    t.integer "lequen",        default: 0
    t.integer "lerbet",        default: 0
    t.integer "lezanne",       default: 0
    t.integer "lozach",        default: 0
    t.integer "medmoun",       default: 0
    t.integer "nguyen",        default: 0
    t.integer "preumont",      default: 0
    t.integer "qrichi",        default: 0
    t.integer "rabineau",      default: 0
    t.integer "ravetta",       default: 0
    t.integer "rael",          default: 0
    t.integer "ren",           default: 0
    t.integer "robina",        default: 0
    t.integer "robind",        default: 0
    t.integer "sahli",         default: 0
    t.integer "scotti",        default: 0
    t.integer "sourice",       default: 0
    t.integer "steiner",       default: 0
    t.integer "thomas",        default: 0
    t.integer "vanel",         default: 0
    t.integer "vital",         default: 0
    t.integer "zhou",          default: 0
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: :cascade do |t|
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_count", default: 0
    t.float    "coeff",      default: 0.0
    t.boolean  "multiple",   default: false
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
    t.integer "abecassis",   default: 0
    t.integer "athor",       default: 0
    t.integer "azizian",     default: 0
    t.integer "beaulieu",    default: 0
    t.integer "boutin",      default: 0
    t.integer "bruneaux",    default: 0
    t.integer "brunod",      default: 0
    t.integer "bustillo",    default: 0
    t.integer "careil",      default: 0
    t.integer "chardon",     default: 0
    t.integer "cortes",      default: 0
    t.integer "diridollou",  default: 0
    t.integer "dumond",      default: 0
    t.integer "fievet",      default: 0
    t.integer "flechelles",  default: 0
    t.integer "gaborit",     default: 0
    t.integer "georges",     default: 0
    t.integer "godefroy",    default: 0
    t.integer "haas",        default: 0
    t.integer "khalfallah",  default: 0
    t.integer "lanfranchi",  default: 0
    t.integer "lecat",       default: 0
    t.integer "ledaguenel",  default: 0
    t.integer "laigret",     default: 0
    t.integer "lengele",     default: 0
    t.integer "lequen",      default: 0
    t.integer "lerbet",      default: 0
    t.integer "lezanne",     default: 0
    t.integer "lozach",      default: 0
    t.integer "medmoun",     default: 0
    t.integer "nguyen",      default: 0
    t.integer "preumont",    default: 0
    t.integer "qrichi",      default: 0
    t.integer "rabineau",    default: 0
    t.integer "ravetta",     default: 0
    t.integer "rael",        default: 0
    t.integer "ren",         default: 0
    t.integer "robina",      default: 0
    t.integer "robind",      default: 0
    t.integer "sahli",       default: 0
    t.integer "scotti",      default: 0
    t.integer "sourice",     default: 0
    t.integer "steiner",     default: 0
    t.integer "thomas",      default: 0
    t.integer "vanel",       default: 0
    t.integer "vital",       default: 0
    t.integer "zhou",        default: 0
  end

  add_index "suggested_coeffs", ["question_id"], name: "index_suggested_coeffs_on_question_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "token"
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "phonenumber"
    t.date    "birthday"
    t.string  "gender"
    t.integer "godfather_id"
  end

  create_table "users_answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "answer_number"
    t.integer "user_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "question_id"
    t.integer "abecassis",   default: 0
    t.integer "athor",       default: 0
    t.integer "azizian",     default: 0
    t.integer "beaulieu",    default: 0
    t.integer "boutin",      default: 0
    t.integer "bruneaux",    default: 0
    t.integer "brunod",      default: 0
    t.integer "bustillo",    default: 0
    t.integer "careil",      default: 0
    t.integer "chardon",     default: 0
    t.integer "cortes",      default: 0
    t.integer "diridollou",  default: 0
    t.integer "dumond",      default: 0
    t.integer "fievet",      default: 0
    t.integer "flechelles",  default: 0
    t.integer "gaborit",     default: 0
    t.integer "georges",     default: 0
    t.integer "godefroy",    default: 0
    t.integer "haas",        default: 0
    t.integer "khalfallah",  default: 0
    t.integer "lanfranchi",  default: 0
    t.integer "lecat",       default: 0
    t.integer "ledaguenel",  default: 0
    t.integer "laigret",     default: 0
    t.integer "lengele",     default: 0
    t.integer "lequen",      default: 0
    t.integer "lerbet",      default: 0
    t.integer "lezanne",     default: 0
    t.integer "lozach",      default: 0
    t.integer "medmoun",     default: 0
    t.integer "nguyen",      default: 0
    t.integer "preumont",    default: 0
    t.integer "qrichi",      default: 0
    t.integer "rabineau",    default: 0
    t.integer "ravetta",     default: 0
    t.integer "rael",        default: 0
    t.integer "ren",         default: 0
    t.integer "robina",      default: 0
    t.integer "robind",      default: 0
    t.integer "sahli",       default: 0
    t.integer "scotti",      default: 0
    t.integer "sourice",     default: 0
    t.integer "steiner",     default: 0
    t.integer "thomas",      default: 0
    t.integer "vanel",       default: 0
    t.integer "vital",       default: 0
    t.integer "zhou",        default: 0
  end

  add_index "votes", ["question_id"], name: "index_votes_on_question_id", using: :btree

end
