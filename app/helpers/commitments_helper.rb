module CommitmentsHelper

  def update_commitments
    current_member.commitment_calendars.each do |commitment_calendar|
      events = google_api_request(
        "calendar", "v3", "events", "list",
        {
          calendarId: commitment_calendar.calendar_id,
          timeMin: DateTime.now,
          timeMax: DateTime.now + 1.week,
          q: "pbl"
        }
      ).data.items

      events.each do |event|
        summary = event.summary
        start_time = event.start.date_time
        end_time = event.end.date_time

        current_member.commitments.where(
          summary: summary,
          start_time: start_time,
          end_time: end_time,
        ).first_or_create!
      end
    end
  end

end
