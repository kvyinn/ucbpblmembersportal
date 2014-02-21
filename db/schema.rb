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

ActiveRecord::Schema.define(:version => 20140203004620) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "applicant_rankings", :force => true do |t|
    t.integer  "applicant"
    t.integer  "value"
    t.text     "notes"
    t.integer  "committee"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "deliberation_id"
  end

  add_index "applicant_rankings", ["deliberation_id"], :name => "index_applicant_rankings_on_deliberation_id"

  create_table "applicants", :force => true do |t|
    t.integer  "preference1"
    t.integer  "preference2"
    t.integer  "preference3"
    t.string   "image"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "deliberation_id"
    t.string   "email"
  end

  add_index "applicants", ["deliberation_id"], :name => "index_applicants_on_deliberation_id"

  create_table "blog_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "member_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "commitment_calendars", :force => true do |t|
    t.integer  "member_id"
    t.string   "calendar_id"
    t.string   "acl_id"
    t.string   "tag"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "commitment_calendars", ["calendar_id"], :name => "index_commitment_calendars_on_calendar_id"
  add_index "commitment_calendars", ["member_id", "calendar_id"], :name => "index_commitment_calendars_on_member_id_and_calendar_id", :unique => true
  add_index "commitment_calendars", ["member_id"], :name => "index_commitment_calendars_on_member_id"

  create_table "commitments", :force => true do |t|
    t.integer  "member_id"
    t.string   "summary"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "day"
    t.integer  "start_hour"
    t.integer  "end_hour"
  end

  add_index "commitments", ["member_id"], :name => "index_commitments_on_member_id"

  create_table "committee_member_types", :force => true do |t|
    t.string   "name"
    t.integer  "tier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "committee_member_types", ["tier"], :name => "index_committee_member_types_on_tier"

  create_table "committee_members", :force => true do |t|
    t.integer  "member_id"
    t.integer  "committee_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "committee_member_type_id"
    t.integer  "semester_id"
  end

  add_index "committee_members", ["committee_id"], :name => "index_committee_members_on_committee_id"
  add_index "committee_members", ["committee_member_type_id"], :name => "cm_type_id"
  add_index "committee_members", ["member_id", "semester_id", "committee_id"], :name => "cm_uniq", :unique => true
  add_index "committee_members", ["member_id"], :name => "index_committee_members_on_member_id"

  create_table "committee_semester_members", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "committee_types", :force => true do |t|
    t.string   "name"
    t.integer  "tier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "committee_types", ["tier"], :name => "index_committee_types_on_tier"

  create_table "committees", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "committee_type_id"
  end

  add_index "committees", ["abbr"], :name => "index_committees_on_abbr"
  add_index "committees", ["committee_type_id"], :name => "index_committees_on_committee_type_id"

  create_table "deliberation_assignments", :force => true do |t|
    t.integer  "deliberation_id"
    t.integer  "applicant"
    t.integer  "committee"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "deliberations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_members", :force => true do |t|
    t.string   "event_id"
    t.integer  "member_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "semester_id"
    t.string   "google_id"
  end

  add_index "event_members", ["event_id", "member_id"], :name => "index_event_members_on_event_id_and_member_id", :unique => true
  add_index "event_members", ["event_id"], :name => "index_event_members_on_event_id"
  add_index "event_members", ["member_id"], :name => "index_event_members_on_member_id"

  create_table "event_points", :force => true do |t|
    t.string   "event_id",                   :null => false
    t.integer  "value",       :default => 0, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "semester_id"
    t.string   "google_id"
  end

  add_index "event_points", ["event_id"], :name => "index_event_points_on_event_id", :unique => true

  create_table "event_semester_members", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "google_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "semester_id"
  end

  create_table "likes", :force => true do |t|
    t.string   "like_type"
    t.integer  "member_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "remember_token"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "old_member_id"
    t.string   "profile"
  end

  add_index "members", ["name"], :name => "index_members_on_name"
  add_index "members", ["provider", "uid"], :name => "index_members_on_provider_and_uid"
  add_index "members", ["remember_token"], :name => "index_members_on_remember_token"

  create_table "old_posts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "points", :force => true do |t|
    t.integer  "member_id",   :null => false
    t.integer  "value",       :null => false
    t.string   "details"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "semester_id"
  end

  add_index "points", ["member_id"], :name => "index_points_on_member_id"

  create_table "post_categories", :force => true do |t|
    t.string   "name"
    t.string   "category_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.string   "title"
    t.integer  "member_id"
    t.integer  "edit_tier"
    t.integer  "view_tier"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "category"
    t.integer  "old_post_id"
    t.datetime "date"
    t.integer  "category_id"
  end

  create_table "reimbursements", :force => true do |t|
    t.integer  "member_id"
    t.float    "amount"
    t.string   "details"
    t.boolean  "processed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reimbursements", ["member_id"], :name => "index_reimbursements_on_member_id"
  add_index "reimbursements", ["processed"], :name => "index_reimbursements_on_processed"

  create_table "semester_members", :force => true do |t|
    t.integer  "semester_id"
    t.integer  "member_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "semesters", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tabling_slot_members", :force => true do |t|
    t.integer  "member_id"
    t.integer  "tabling_slot_id"
    t.integer  "status_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "tabling_slot_members", ["tabling_slot_id", "member_id"], :name => "index_tabling_slot_members_on_tabling_slot_id_and_member_id", :unique => true

  create_table "tabling_slots", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
