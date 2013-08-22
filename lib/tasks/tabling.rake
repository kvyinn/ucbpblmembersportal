require 'rjb'
require 'csv'

tabling_dir = File.join(Rails.root, "lib/tabling")
Rjb::load(classpath = tabling_dir)

namespace :tabling do
  desc "Compile necessary files"
  task :compile do
    system "cd #{tabling_dir} && javac -d . *.java"
  end

  desc "Show tabling settings for the week"
  task settings: :compile do
    TablingSlot = Rjb::import("tablingassigner.TablingSlot")
    DayOfWeek = Rjb::import("tablingassigner.DayOfWeek")
    ts = TablingSlot.new(DayOfWeek.MONDAY, 900, 1100)
    p "#{ts.DOW}"
  end

  desc "Read the members and schedules csv and view the available slots"
  task available: [:compile, :environment] do
    TablingAssignerTemp = Rjb::import("tablingassigner.TablingAssignerTemp")
    Dir.chdir(tabling_dir)
    TablingAssignerTemp.run

    CSV.foreach(File.join(tabling_dir, 'available_slots.csv')) do |row|
      date = to_datetime(row[1], row[2])
      p "#{date}"
    end
  end

  desc "Assign and view the initial schedule"
  task initial: :environment do
    TablingAssigner = Rjb::import("tablingassigner.TablingAssigner")
    Dir.chdir(tabling_dir)
    TablingAssigner.run

    CSV.foreach(File.join(tabling_dir, 'initial_schedule.csv')) do |row|
      p row
    end
  end
end

namespace :members do

  desc "Generate random members, officers, and committees"
  task generate: :environment do
    Member.destroy_all
    Committee.destroy_all
    CommitteeType.destroy_all
    CommitteeMemberType.destroy_all

    100.times { FactoryGirl.create(:member) }
    10.times { FactoryGirl.create(:committee) }
    5.times { FactoryGirl.create(:committee_member_type) }

    Member.all.each do |member|
      committee_member = member.committee_members.create(
        committee_id: Committee.first(offset: rand(Committee.count)).id,
        committee_member_type_id: CommitteeMemberType.first(offset: rand(CommitteeMemberType.count)).id,
      )
    end
  end

end

def to_datetime(day, time)
  hour = 0
  min = 0
  if time.length == 3
    hour = time[0,1]
  else
    hour = time[0,2]
  end

  min = time[-2,2]
  DateTime.parse("#{day} #{hour}:#{min}") + 1.week
end

def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end
