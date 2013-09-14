module CommitmentsHelper

  def update_commitments
    current_member.commitments.destroy_all

    current_member.commitment_calendars.each do |commitment_calendar|
      events = google_api_request(
        "calendar", "v3", "events", "list",
        {
          calendarId: commitment_calendar.calendar_id,
          timeMin: DateTime.now,
          timeMax: DateTime.now + 1.week,
          q: commitment_calendar.tag
        }
      ).data.items

      events = process_google_events(events)

      events.each do |event|
        summary = event[:summary]
        start_time = event[:start_time]
        end_time = event[:end_time]

        current_member.commitments.where(
          summary: summary,
          start_time: start_time,
          end_time: end_time,
        ).first_or_create!
      end
    end
  end

end
