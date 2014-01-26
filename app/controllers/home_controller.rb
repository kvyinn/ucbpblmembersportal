class HomeController < ApplicationController

  def home
    @tabling_slots = current_member.tabling_slots.where(
      "start_time >= :start", start: tabling_start
    )
    # days of this week
    @days = Hash.new
    today = Chronic.parse("today")
    @events = Event.all(:conditions => ["start_time BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day+1.week])
    # @days[today] = events
    # puts @events
    # p 'that was days'
    # render "homepage"
    # Post.sync_with_old_posts
    # render "test"
  end

  def coolmethod
  	CommitteeMember.all.each do |cm|
  		cm.semester = Semester.find(1)
  		cm.save
  	end
  end

end
