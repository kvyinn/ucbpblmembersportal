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

ActiveRecord::Schema.define(:version => 20130926192049) do

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
  end

  add_index "committee_members", ["committee_id"], :name => "index_committee_members_on_committee_id"
  add_index "committee_members", ["committee_member_type_id"], :name => "cm_type_id"
  add_index "committee_members", ["member_id", "committee_id"], :name => "cm_uniq", :unique => true
  add_index "committee_members", ["member_id"], :name => "index_committee_members_on_member_id"

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

  create_table "event_members", :force => true do |t|
    t.integer  "event_id"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_members", ["event_id", "member_id"], :name => "index_event_members_on_event_id_and_member_id", :unique => true
  add_index "event_members", ["event_id"], :name => "index_event_members_on_event_id"
  add_index "event_members", ["member_id"], :name => "index_event_members_on_member_id"

  create_table "members", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "remember_token"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "old_member_id"
  end

  add_index "members", ["name"], :name => "index_members_on_name"
  add_index "members", ["provider", "uid"], :name => "index_members_on_provider_and_uid"
  add_index "members", ["remember_token"], :name => "index_members_on_remember_token"

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
