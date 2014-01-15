# require 'rjb'
# require 'csv'

module TablingSlotsHelper

#   @@tabling_dir = File.join(Rails.root, "lib/tabling")
#   @@write_dir = File.join(Rails.root, "tmp")
#   system "cd #{@@tabling_dir} && javac -d . *.java"
#   Rjb::load(classpath = @@tabling_dir)
#   TablingAssignerTemp = Rjb::import("tablingassigner.TablingAssignerTemp")
#   TablingAssigner = Rjb::import("tablingassigner.TablingAssigner")
#   TablingSlotJava = Rjb::import("tablingassigner.TablingSlot")
#   TimeJava = Rjb::import("tablingassigner.Time")

#   # Write necessary files for the tabling assigner
#   def write_init_files
#     list = []
#     Dir.chdir(@@tabling_dir)

#     # Clear files if exists
#     File.open(File.join(@@write_dir, 'members.csv'), 'w') {|file| file.truncate(0) }
#     File.open(File.join(@@write_dir, 'schedules.csv'), 'w') {|file| file.truncate(0) }

#     Member.all.each do |member|
#       if member.commitments.count > 0 and member.tier and member.tier >= 1 and member != Member.where(name: "Keien Ohta").first
#         CSV.open(File.join(@@write_dir, 'members.csv'), "ab") { |csv| csv << [member.id, member.name, member.tier+2] }

#         member.commitments.each do |commitment|

#           if commitment.start_time and commitment.end_time

#             start_time = this_week(commitment.start_time)
#             end_time = this_week(commitment.end_time)

#             day = "-----"
#             day[start_time.cwday-1] = start_time.strftime("%a").upcase[0] if start_time.cwday <= 5

#             end_date = end_time.strftime("%Y%m%d")
#             start_date = start_time.strftime("%Y%m%d")

#             start_time = start_time.strftime("%H%M")
#             end_time = end_time.strftime("%H%M")

#             list << [member.id, day, start_date, end_date, start_time, end_time]

#             CSV.open(File.join(@@write_dir, 'schedules.csv'), "ab") do |csv|
#               csv << [member.id, day, start_date, end_date, start_time, end_time]
#             end
#           end
#         end
#       end
#     end

#     return list
#   end


#   def generate_schedule
#     Rjb::load(classpath = @@tabling_dir)
#     @tabling_dir = File.join(Rails.root, "lib/tabling")

#     Dir.chdir(@tabling_dir)

#     start_time = TablingSlotJava.startOfDay().toString()[0..1].to_i
#     end_time = TablingSlotJava.endOfDay().toString()[0..1].to_i

#     TablingSlot.where(
#       "start_time >= :tabling_start and start_time <= :tabling_end",
#       tabling_start: tabling_start,
#       tabling_end: tabling_end,
#     ).destroy_all

#     Date::DAYNAMES[1..5].each do |day|
#       (start_time..end_time-1).each do |hour|
#         TablingSlot.where(
#           start_time: Chronic.parse("#{hour} this #{day}"),
#           end_time: Chronic.parse("#{hour + 1} this #{day}")
#         ).first_or_create!
#       end
#     end

#     begin
#       TablingAssignerTemp.run(@@write_dir)

#       TablingAssigner.run(@@write_dir)

#     rescue IllegalArgumentException => e
#       p e.class
#       return false
#     end

#     CSV.foreach(File.join(@@write_dir, 'initial_schedule.csv')) do |row|
#       member = Member.find(row[0])
#       tabling_slot = TablingSlot.where(
#         start_time: to_datetime(row[1], row[2]),
#       ).first

#       if tabling_slot
#         member.tabling_slots << (tabling_slot)
#         member.tabling_slot_member(tabling_slot).set_status_to :attending
#       else
#         p "Tabling slot not found for #{row[1]}, #{row[2]}"
#       end

#     end

#     return true
#   end
end
