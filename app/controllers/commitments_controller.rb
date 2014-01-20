class CommitmentsController < ApplicationController

  def index
    @commitments = current_member.commitments
    if current_member.admin?
      @submitted_members = Commitment.all.map do |commitment|
        commitment.member
      end.uniq.map { |member| member.name }
    end
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
          q: commitment_calendar.tag
        }
      ).data.items
    end

    @events = process_google_events(@events.flatten, this_week: true)

    @events = @events.flatten.sort_by {|event| event[:start_time]}
  end

  def availability
    @commitments = current_member.commitments
    @pbl_commitments = Hash.new
    Member.all.each do |member|
      @pbl_commitments[member.id] = Array.new
      for c in member.commitments
        if c.day and c.start_hour and c.end_hour
          @pbl_commitments[member.id] << "#"+c.day.to_s+" #"+c.start_hour.to_s
        end
      end
    end
  end

  def update_availability
    # mem = current_member.cms.sample
    current_member.commitments.destroy_all
    timeslots = params[:slots]
    for key in timeslots.keys
      for hour in timeslots[key]
        day = key.to_i
        start_hour = hour.to_i
        end_hour = hour.to_i + 1
        c = Commitment.new
        c.member_id = current_member.id
        c.day = day
        c.start_hour = start_hour
        c.end_hour = end_hour
        c.save
      end
    end
    render json: "saved your commitments"
  end

end
