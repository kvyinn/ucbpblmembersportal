# == Description
#
# Controller for pages related to points
class PointsController < ApplicationController
  # Show point breakdown for #current_member and his committee.
  #
  # === Variables
  # - recently_earned: a list of occurences that earned the member points, sorted in reverse
  # chronological order.
  def index
    @semester = Semester.current_semester
    if params[:semester]
      s = Semester.find(params[:semester])
      if s
        @semester = s
      end
    end
    @recently_earned = []

    # Add events
    current_member.event_members.each do |event_member|
      event_points = EventPoints.where(event_id: event_member.event_id).first if event_member.semester == @semester

      if event_points
        @recently_earned << { title: Event.find(event_points.event_id).name , points: event_points.value }
      end
    end

    # Add tabling
    current_member.attended_slots.each do |tabling_slot|
      if tabling_slot.start_time >= Semester.current_semester.start_date

          @recently_earned << {
            title: "Tabling on #{tabling_slot.start_time.strftime("%A, %D %l:%M%p")}",
            points: TablingSlot::POINTS
          }
      end
    end
  end

  def d3_points
    @committees = Committee.all
  end
  def get_d3_data
    @members = Member.all
    @member_points = Array.new
    @members = @members.sort_by { |m|  m.total_points("all")}
    for mem in @members
      object = Hash.new
      object["name"] = mem.name
      object["points"] = mem.total_points("all")
      if mem.primary_committee
        object["committee"] = mem.primary_committee.name
      else
        object["committee"] = "none"
      end
      @member_points<<object
    end
    render json: @member_points
  end
  # Show rankings of committees
  #
  # == Variables
  # - ranked_committees: list of committees, sorted by their rating.
  def rankings
    @ranked_committees = Committee.all.sort_by { |committee| committee.rating }.reverse
  end
end
