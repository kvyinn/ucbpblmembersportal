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
    @recently_earned = []

    # Load events for names
    events = {}
    google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: pbl_events_calendar_id,
        timeMin: beginning_of_fall_semester,
        timeMax: DateTime.now,
      }
    ).data.items.each do |event|
      events[event.id] = event.summary
    end

    # Add events
    current_member.event_members.order("created_at DESC").each do |event_member|
      event_points = EventPoints.where(event_id: event_member.event_id).first

      if event_points
        @recently_earned << { title: events[event_member.event_id], points: event_points.value }
      end
    end

    # Add tabling
    current_member.attended_slots.each do |tabling_slot|
      @recently_earned << {
        title: "Tabling on #{tabling_slot.start_time.strftime("%A, %D %l:%M%p")}",
        points: TablingSlot::POINTS
      }
    end
  end

  # Show rankings of committees
  #
  # == Variables
  # - ranked_committees: list of committees, sorted by their rating.
  def rankings
    @ranked_committees = Committee.all.sort_by { |committee| committee.rating }.reverse
  end
end
