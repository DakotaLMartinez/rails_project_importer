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

ActiveRecord::Schema.define(version: 2020_01_29_225838) do

  create_table "batch_progress_report_rows", force: :cascade do |t|
    t.integer "batch_progress_report_id"
    t.string "full_name"
    t.integer "completed_lessons_count"
    t.integer "total_lessons_count"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
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
    t.string "iteration"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "project_reviews", force: :cascade do |t|
    t.integer "student_id"
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "start_time"
    t.string "name"
    t.string "email"
    t.string "date"
    t.string "github_url"
    t.string "cohort_name"
    t.string "learn_profile_url"
    t.string "assessment"
    t.text "notes"
    t.text "email_to_student"
    t.boolean "pass"
    t.integer "grade"
    t.boolean "action_required", default: true
    t.index ["project_id"], name: "index_project_reviews_on_project_id"
    t.index ["student_id"], name: "index_project_reviews_on_student_id"
    t.index ["user_id"], name: "index_project_reviews_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_type"
    t.string "status"
    t.string "github_url"
    t.string "blog_url"
    t.string "video_url"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "portfolio_project_id"
    t.index ["student_id"], name: "index_projects_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_batch_id"
    t.string "github_username"
  end

  create_table "user_students", force: :cascade do |t|
    t.integer "user_id"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_user_students_on_student_id"
    t.index ["user_id"], name: "index_user_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
