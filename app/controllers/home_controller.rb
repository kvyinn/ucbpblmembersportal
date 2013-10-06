class HomeController < ApplicationController

  def home
    @tabling_slots = current_member.tabling_slots.where(
      "start_time >= :start", start: tabling_start
    )
  end

end
