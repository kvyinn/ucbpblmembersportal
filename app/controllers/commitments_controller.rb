class CommitmentsController < ApplicationController

  def index
    @commitments = current_member.commitments
  end

  def update_all
    update_commitments

    redirect_to commitments_path
  end

  def preview
    @events = []
    current_member.commitment_calendars.each do |commitment_calendar|
      @events << google_api_request(
        "calendar", "v3", "events", "list",
        {
          calendarId: commitment_calendar.calendar_id,
          timeMin: DateTime.now,
          timeMax: DateTime.now + 1.week,
          q: "pbl"
        }
      ).data.items
    end

    @events = process_google_events(@events.flatten)

    @events = @events.flatten.sort_by {|event| event[:start_time]}
  end

end
