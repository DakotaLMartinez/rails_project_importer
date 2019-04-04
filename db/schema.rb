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

ActiveRecord::Schema.define(version: 2019_04_04_044809) do

  create_table "batch_progress_report_rows", force: :cascade do |t|
    t.integer "batch_progress_report_id"
    t.string "full_name"
    t.integer "completed_lessons_count"
    t.integer "total_lessons_count"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_progress_report_id"], name: "index_batch_progress_report_rows_on_batch_progress_report_id"
  end

  create_table "batch_progress_reports", force: :cascade do |t|
    t.integer "batch_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_progress_reports_on_batch_id"
  end

  create_table "batches", force: :cascade do |t|
    t.integer "batch_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
