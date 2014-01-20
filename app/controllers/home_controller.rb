class HomeController < ApplicationController

  def home
    @tabling_slots = current_member.tabling_slots.where(
      "start_time >= :start", start: tabling_start
    )
    # coolmethod
    render "test"
  end

  def coolmethod
  	CommitteeMember.all.each do |cm|
  		cm.semester = Semester.find(1)
  		cm.save
  	end
  end

end
