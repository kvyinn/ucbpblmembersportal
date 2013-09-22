require 'rjb'
require 'csv'

module TablingSlotsHelper

  @@tabling_dir = File.join(Rails.root, "lib/tabling")
  @@write_dir = File.join(Rails.root, "tmp")
  system "cd #{@@tabling_dir} && javac -d . *.java"
  Rjb::load(classpath = @@tabling_dir)
  TablingAssignerTemp = Rjb::import("tablingassigner.TablingAssignerTemp")
  TablingAssigner = Rjb::import("tablingassigner.TablingAssigner")

  # Write necessary files for the tabling assigner
  def write_init_files
    list = []
    Dir.chdir(@@tabling_dir)

    # Clear files if exists
    File.open(File.join(@@write_dir, 'members.csv'), 'w') {|file| file.truncate(0) }
    File.open(File.join(@@write_dir, 'schedules.csv'), 'w') {|file| file.truncate(0) }

    Member.all.each do |member|
      if member.commitments.count > 0 and member.tier and member.tier >= 1 and member != Member.where(name: "Keien Ohta").first
        CSV.open(File.join(@@write_dir, 'members.csv'), "ab") { |csv| csv << [member.id, member.name, member.tier+2] }
        p [member.id, member.name, member.tier+2]

        member.commitments.each do |commitment|

          if commitment.start_time and commitment.end_time

            day = "-----"
            start_time = commitment.start_time.to_datetime
            day[start_time.cwday-1] = start_time.strftime("%a").upcase[0] if start_time.cwday <= 5

            end_date = commitment.end_time.strftime("%Y%m%d")
            start_date = commitment.start_time.strftime("%Y%m%d")

            start_time = commitment.start_time.strftime("%H%M")
            end_time = commitment.end_time.strftime("%H%M")

            list << [member.id, day, start_date, end_date, start_time, end_time]

            CSV.open(File.join(@@write_dir, 'schedules.csv'), "ab") do |csv|
              p [member.id, day, start_date, end_date, start_time, end_time]
              csv << [member.id, day, start_date, end_date, start_time, end_time]
            end
          end
        end
      end
    end

    return list
  end


  def generate_schedule
    @tabling_dir = File.join(Rails.root, "lib/tabling")

    Dir.chdir(@tabling_dir)
    TablingAssignerTemp.run(@@write_dir)

    TablingAssigner.run(@@write_dir)

    TablingSlot.destroy_all

    CSV.foreach(File.join(@@write_dir, 'initial_schedule.csv')) do |row|
      member = Member.find(row[0] % Member.count)
      tabling_slot = member.tabling_slots << TablingSlot.where(
        start_time: to_datetime(row[1], row[2]),
        end_time: to_datetime(row[1], row[3]),
      ).first_or_create!
      member.tabling_slot_members.where(tabling_slot_id: tabling_slot).first.set_status_to :available
    end
  end


end
