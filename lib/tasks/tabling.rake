# require 'rjb'
# require 'csv'

# tabling_dir = File.join(Rails.root, "lib/tabling")
# write_dir = File.join(Rails.root, "tmp")
# Rjb::load(classpath = tabling_dir)

# namespace :tabling do
#   desc "Compile necessary files"
#   task :compile do
#     system "cd #{tabling_dir} && javac -d . *.java"
#   end

#   desc "Show tabling settings for the week"
#   task settings: :compile do
#     TablingSlot = Rjb::import("tablingassigner.TablingSlot")
#     DayOfWeek = Rjb::import("tablingassigner.DayOfWeek")
#     ts = TablingSlot.new(DayOfWeek.MONDAY, 900, 1100)
#     p "#{ts.DOW}"
#   end

#   desc "Read the members and schedules csv and view the available slots"
#   task available: [:compile, :environment] do
#     TablingAssignerTemp = Rjb::import("tablingassigner.TablingAssignerTemp")
#     Dir.chdir(tabling_dir)
#     TablingAssignerTemp.run

#     CSV.foreach(File.join(tabling_dir, 'available_slots.csv')) do |row|
#       date = to_datetime(row[1], row[2])
#       p "#{date}"
#     end
#   end

#   desc "View the members and schedules csv files"
#   task :view do
#     p "========= members.csv ============"
#     CSV.foreach(File.join(write_dir, 'members.csv')) do |row|
#       p row
#     end

#     p "========= schedules.csv ============"
#     CSV.foreach(File.join(write_dir, 'schedules.csv')) do |row|
#       p row
#     end
#   end

#   desc "Assign and view the initial schedule"
#   task initial: :environment do
#     TablingAssigner = Rjb::import("tablingassigner.TablingAssigner")
#     Dir.chdir(tabling_dir)
#     TablingAssigner.run

#     CSV.foreach(File.join(tabling_dir, 'initial_schedule.csv')) do |row|
#       p row
#     end
#   end

#   desc "Generate tabling"
#   task generate_schedule: :environment do
#     @tabling_dir = File.join(Rails.root, "lib/tabling")

#     Dir.chdir(@tabling_dir)
#     TablingAssignerTemp = Rjb::import("tablingassigner.TablingAssignerTemp")
#     TablingAssigner = Rjb::import("tablingassigner.TablingAssigner")
#     TablingAssignerTemp.run(@tabling_dir)

#     TablingAssigner.run(@tabling_dir)

#     TablingSlot.destroy_all

#     CSV.foreach(File.join(@tabling_dir, 'initial_schedule.csv')) do |row|
#       member = Member.find(row[0] % Member.count)
#       tabling_slot = member.tabling_slots << TablingSlot.where(
#         start_time: to_datetime(row[1], row[2]),
#         end_time: to_datetime(row[1], row[3]),
#       ).first_or_create!
#       member.tabling_slot_members.where(tabling_slot_id: tabling_slot).first.set_status_to :available
#     end
#   end
# end

# namespace :members do

#   desc "Generate random members, officers, and committees"
#   task generate: :environment do
#     Member.destroy_all
#     Committee.destroy_all
#     CommitteeType.destroy_all
#     CommitteeMemberType.destroy_all

#     100.times { FactoryGirl.create(:member) }
#     10.times { FactoryGirl.create(:committee) }
#     5.times { FactoryGirl.create(:committee_member_type) }

#     Member.all.each do |member|
#       committee_member = member.committee_members.create(
#         committee_id: Committee.first(offset: rand(Committee.count)).id,
#         committee_member_type_id: CommitteeMemberType.first(offset: rand(CommitteeMemberType.count)).id,
#       )
#     end
#   end

# end

# def to_datetime(day, time)
#   hour = time.to_i/100

#   datetime = date_of_next(day).change(offset: "-0700") + hour.hours
#   return datetime
# end

# def date_of_next(day)
#   date  = Date.parse(day)
#   delta = date > Date.today ? 0 : 7
#   date + delta
# end
