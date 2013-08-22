class CalendarsController < ApplicationController

  def index
    results = google_api_request('calendar', 'v3', 'calendar_list', 'list', {})
    @calendars = results.data.items.map { |item| item if item.access_role == "owner" }.compact
  end

  def show
    results = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: revert_google_calendar_id(params[:id]),
        timeMin: DateTime.now - 1.month,
        timeMax: DateTime.now + 1.month,
        q: "",
      }
    )
    p results
    @events = results.data.items.map do |item|
      { title: item.summary,
        # starts_at: item.start.date,
        # ends_at: item.end.date,
        id: item.id
      }
    end.compact

    @calendar_id = params[:id]
  end

  def confirm_clear
    @calendar = params[:id]
  end

  def clear
    events = google_api_request(
      'calendar', 'v3', 'events', 'list', {
        calendarId: revert_google_calendar_id(params[:id]),
        timeMin: DateTime.now,
        timeMax: DateTime.now + 2.weeks,
      }
    ).data.items.each do |event|
      google_api_request(
        'calendar', 'v3', 'events', 'delete', {
          calendarId: revert_google_calendar_id(params[:id]),
          eventId: event.id,
        }
      )
    end

    redirect_to root_path
  end

end
