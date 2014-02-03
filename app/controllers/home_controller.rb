class HomeController < ApplicationController

  def home
    @tabling_slots = current_member.tabling_slots.where(
      "start_time >= :start", start: tabling_start
    )
    # days of this week
    # @days = Hash.new
    # today = Chronic.parse("today")
    @events = Event.all(:conditions => ["start_time BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day+1.week])

    start_day = tabling_start
    end_day = tabling_end

     @week_posts = Post.where("posts.date IS NOT NULL").where(
      "date >= :tabling_start and date <= :tabling_end",
      tabling_start: start_day,
      tabling_end: end_day,
    ).order(:date)

    # if !@week_posts.empty?

    #   @days = Hash.new
    #   @week_posts.each do |post|
    #     @days[post.day.wday] ||= Array.new
    #     day = @days[post.date.wday]
    #     @days << day
    #   end
    # end
    # keys are days and value is a list of tuples. tuple is name of event and type of event?
    notifs = Hash.new
    render "homepage"
  end

  def coolmethod
  	CommitteeMember.all.each do |cm|
  		cm.semester = Semester.find(1)
  		cm.save
  	end
  end

end
