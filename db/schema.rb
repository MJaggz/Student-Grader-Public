# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_02_233912) do
  create_table "availabilities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "day"
    t.time "end_time"
    t.integer "grader_application_id", null: false
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.index ["grader_application_id"], name: "index_availabilities_on_grader_application_id"
  end

  create_table "course_preferences", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "grader_application_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_preferences_on_course_id"
    t.index ["grader_application_id"], name: "index_course_preferences_on_grader_application_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "academic_career"
    t.string "academic_group"
    t.string "campus"
    t.string "catalog_number"
    t.string "component"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "subject"
    t.string "title"
    t.string "units"
    t.datetime "updated_at", null: false
  end

  create_table "grader_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "expected_graduation"
    t.string "phone_number"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_grader_applications_on_user_id"
  end

  create_table "grader_assignments", force: :cascade do |t|
    t.datetime "assigned_at"
    t.datetime "created_at", null: false
    t.integer "grader_application_id", null: false
    t.integer "section_id", null: false
    t.datetime "updated_at", null: false
    t.index ["grader_application_id"], name: "index_grader_assignments_on_grader_application_id"
    t.index ["section_id", "grader_application_id"], name: "idx_on_section_id_grader_application_id_3157eb372f", unique: true
    t.index ["section_id"], name: "index_grader_assignments_on_section_id"
  end

  create_table "grader_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fulfilled_date"
    t.integer "num_graders_assigned", default: 0, null: false
    t.integer "num_graders_requested"
    t.datetime "request_date"
    t.string "request_number"
    t.string "requestor_name"
    t.integer "section_id", null: false
    t.datetime "updated_at", null: false
    t.index ["request_number"], name: "index_grader_requests_on_request_number", unique: true
    t.index ["section_id"], name: "index_grader_requests_on_section_id", unique: true
  end

  create_table "recommendations", force: :cascade do |t|
    t.string "course"
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "last_name_id"
    t.string "recommended_by"
    t.string "section"
    t.boolean "status", default: false, null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.integer "class_number"
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "credit_hours"
    t.string "days"
    t.integer "graders_required", default: 1, null: false
    t.string "instruction_mode"
    t.string "location"
    t.string "section_number"
    t.string "term"
    t.string "times"
    t.datetime "updated_at", null: false
    t.index ["course_id", "term", "section_number"], name: "index_sections_on_course_term_and_section_number", unique: true
    t.index ["course_id"], name: "index_sections_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "grader_applications"
  add_foreign_key "course_preferences", "courses"
  add_foreign_key "course_preferences", "grader_applications"
  add_foreign_key "grader_applications", "users"
  add_foreign_key "grader_assignments", "grader_applications"
  add_foreign_key "grader_assignments", "sections"
  add_foreign_key "grader_requests", "sections"
  add_foreign_key "sections", "courses"
end
