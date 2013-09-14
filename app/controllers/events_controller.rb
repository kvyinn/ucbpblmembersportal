class EventsController < ApplicationController

  def show
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    @event = google_api_request(
      'calendar', 'v3', 'events', 'get', {
        eventId: params[:id],
        calendarId: @calendar_id
      }
    ).data

    @attendees = EventMember.where(event_id: @event.id).map do |event_member|
      event_member.member
    end.uniq

    @taking_attendance = params[:calendar_id].nil?
  end

  def index
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    past_events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        timeMin: beginning_of_fall_semester,
        timeMax: DateTime.now,
      }
    ).data.items

    upcoming_events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        timeMin: DateTime.now,
        timeMax: DateTime.now + 1.month,
      }
    ).data.items

    @past_events = process_google_events(past_events)
    @upcoming_events = process_google_events(upcoming_events)
  end

end
