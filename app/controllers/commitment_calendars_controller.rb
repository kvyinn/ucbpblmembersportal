class CommitmentCalendarsController < ApplicationController

  def index
    @commitment_calendars = current_member.commitment_calendars

    load_summaries_for(@commitment_calendars)

    cal_result = google_api_request('calendar', 'v3', 'calendar_list', 'list', {})
    @unsaved_calendars = cal_result.data.items.map do |calendar|
      calendar if @commitment_calendars.where(calendar_id: calendar.id).empty?
    end.compact
  end

  def write
    write_init_files
    redirect_to commitment_calendars_path
  end

  def create
    current_member.commitment_calendars << CommitmentCalendar.new(params[:commitment_calendar])
    redirect_to commitment_calendars_path
  end

  def destroy
    CommitmentCalendar.find(params[:id]).destroy
    redirect_to commitment_calendars_path
  end

end
