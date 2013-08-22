module CommitmentCalendarsHelper

  def load_summaries_for(commitment_calendars)
    commitment_calendars.each do |commitment_calendar|
      result = google_api_request(
        'calendar', 'v3', 'calendar_list', 'get', { calendarId: commitment_calendar.calendar_id }
      )
      commitment_calendar.summary = result.data.summary
    end
  end

end
