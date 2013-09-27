class HomeController < ApplicationController

  def home
    @tabling_slots = current_member.tabling_slots
  end

end
