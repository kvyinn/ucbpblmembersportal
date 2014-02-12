class HomeController < ApplicationController

  def home
    @tabling_slots = current_member.tabling_slots.where(
      "start_time >= :start", start: tabling_start
    )
    # days of this week
    # @days = Hash.new
    # today = Chronic.parse("today")
    @events = Event.all(:conditions => ["start_time BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day+1.week])
    @days = Hash.new
    @event_days = Hash.new
    start_day = tabling_start
    end_day = tabling_end

     @week_posts = Post.where(['date > ?', tabling_start]
      ).where(['date <= ?', tabling_end]
     ).order(:date)

 # @week_posts = Post.where("posts.date IS NOT NULL").where(
 #      "date >= :tabling_start and date <= :tabling_end",
 #      tabling_start: start_day,
 #      tabling_end: end_day,
 #    ).order(:date)

     @week_events = Event.where(['start_time > ?', tabling_start]
      ).where(['start_time <= ?', tabling_end]
     ).order(:start_time)
     puts @week_events
     while start_day < end_day
      @event_days[start_day.strftime("%A, %D")] = Array.new
      @days[start_day.strftime("%A, %D")] = Array.new
      start_day = start_day + 1.day
    end

    if !@week_posts.empty?
      @week_posts.each do |post|
        @days[post.date.strftime("%A, %D")] ||= Array.new
        @days[post.date.strftime("%A, %D")] << post
      end

    end
    if !@week_events.empty?
      @week_events.each do |event|
        @event_days[event.start_time.strftime("%A, %D")] ||= Array.new
        @event_days[event.start_time.strftime("%A, %D")] << event
      end
    end
    # keys are days and value is a list of tuples. tuple is name of event and type of event?
    notifs = Hash.new
    render "homepage"
    # render "test"
  end

  def test
    render 'test'
  end
  def coolmethod
  	CommitteeMember.all.each do |cm|
  		cm.semester = Semester.find(1)
  		cm.save
  	end
  end

end
