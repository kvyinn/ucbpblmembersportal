require 'rjb'
require 'csv'

module TablingSlotsHelper

  @@tabling_dir = File.join(Rails.root, "lib/tabling")
  system "cd #{@@tabling_dir} && javac -d . *.java"
  Rjb::load(classpath = @@tabling_dir)
  TablingAssignerTemp = Rjb::import("tablingassigner.TablingAssignerTemp")
  TablingAssigner = Rjb::import("tablingassigner.TablingAssigner")

  # Write necessary files for the tabling assigner
  def write_init_files
    Dir.chdir(@@tabling_dir)

    # Clear files if exists
    File.open('members.csv', 'w') {|file| file.truncate(0) }
    File.open('schedules.csv', 'w') {|file| file.truncate(0) }

    Member.all.each do |member|
      p member.name
      CSV.open("members.csv", "ab") { |csv| csv << [member.id, member.name, rand(4..5)] }

      # Dummy lines (still doesn't work)
=begin
      if member.commitment_calendars.empty?
        CSV.open("schedules.csv", "ab") do |csv|
          csv << [member.id, "M----", 20130826, 20130826, 2000, 2100]
        end
      end
=end

      member.commitment_calendars.each do |commitment_calendar|
        events = google_api_request(
          "calendar", "v3", "events", "list",
          {
            calendarId: commitment_calendar.calendar_id,
            timeMin: DateTime.now,
            timeMax: DateTime.now + 1.week,
            q: "pbl"
          }
        ).data.items

        events.each do |event|
          day = "-----"
          start_time = event.start.dateTime.to_datetime
          day[start_time.cwday-1] = start_time.strftime("%a").upcase[0]
          p day

          end_date = event.end.dateTime.strftime("%Y%m%d")
          start_date = event.start.dateTime.strftime("%Y%m%d")

          start_time = event.start.dateTime.strftime("%H%M")
          end_time = event.end.dateTime.strftime("%H%M")

          CSV.open("schedules.csv", "ab") do |csv|
            csv << [member.id, day, start_date, end_date, start_time, end_time]
          end
        end
      end
    end
  end

  def generate_schedule
    @tabling_dir = File.join(Rails.root, "lib/tabling")

    Dir.chdir(@tabling_dir)
    # TablingAssignerTemp.run

    TablingAssigner.run

    TablingSlot.destroy_all

    CSV.foreach(File.join(@tabling_dir, 'initial_schedule.csv')) do |row|
      member = Member.find(row[0] % Member.count)
      tabling_slot = member.tabling_slots << TablingSlot.where(
        start_time: to_datetime(row[1], row[2]),
        end_time: to_datetime(row[1], row[3]),
      ).first_or_create!
      member.tabling_slot_members.where(tabling_slot_id: tabling_slot).first.set_status_to :available
    end
  end

  def date_of_next(day)
    date  = Date.parse(day)
    delta = date > Date.today ? 0 : 7
    date + delta
  end

  def to_datetime(day, time)
    hour = time.to_i/100

    datetime = date_of_next(day).change(offset: "-0700") + hour.hours
    p datetime
    return datetime
  end

end
