# Controller for EventPoints
class EventPointsController < ApplicationController

  before_filter :admin_member

  # Show points per event.
  #
  # === Variables
  # - events: list of events to show
  def index

    # Load events
    @event_points = []
    events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: pbl_events_calendar_id,
        timeMin: beginning_of_fall_semester,
        timeMax: DateTime.now,
      }
    ).data.items

    # Look up point values, or assign the default value of 0
    # events.each do |event|
    Event.all.each do |event|
      event_points = EventPoints.where(event_id: event.id).first
      points = event_points ? event_points.value : 0

      @event_points << { event: event, points: points }
    end

  end

  # Mass-assign points to a set of events.
  #
  # === Request Body
  # - event_points: an array of hash used to initialize an EventPoint
  def update_all
    params[:event_ids].zip(params[:points]).map do |item|
      { event_id: item[0], value: item[1] }
    end.each do |attributes|
      # google_id = attributes[:event_id]
      # puts google_id
      # event = Event.where(google_id: google_id)
      # puts event
      # puts "that was your event was it right?"
      # if event.length != 0
      # event = event.first
      event_points = EventPoints.where(event_id: attributes[:event_id]).first_or_initialize
      event_points.value = attributes[:value]

      if !event_points.save
        redirect_to event_points_path, notice: "Something was wrong with the input!"
        return
      end
    end
    # end
    redirect_to event_points_path, notice: "You have updated event point values!"
  end

end
