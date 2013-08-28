class EventsController < ApplicationController

  def show
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    @event = google_api_request(
      'calendar', 'v3', 'events', 'get', {
        eventId: params[:id],
        calendarId: @calendar_id
      }
    ).data

    @taking_attendance = params[:calendar_id].nil?
  end

  def index
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    @events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        timeMin: DateTime.now,
        timeMax: DateTime.now + 1.month,
        q: "pbl"
      }
    ).data.items

    @events = process_google_events(@events)
  end

end
