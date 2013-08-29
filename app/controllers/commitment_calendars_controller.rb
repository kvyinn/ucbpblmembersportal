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
    @list = write_init_files
    generate_schedule
    redirect_to tabling_slots_path
  end

  def create
    commitment_calendar = CommitmentCalendar.new(params[:commitment_calendar])
    current_member.commitment_calendars << commitment_calendar

    rule = { scope: { type: "user", value: "keien.is.testing@gmail.com" }, role: "reader" }
    acl = google_api_request(
      "calendar", "v3", "acl", "insert",
      {
        calendarId: params[:commitment_calendar][:calendar_id]
      },
      JSON.dump(rule)
    ).data

    commitment_calendar.acl_id = acl.id
    commitment_calendar.save

    redirect_to commitment_calendars_path
  end

  def destroy
    commitment_calendar = CommitmentCalendar.find(params[:id]).destroy
    @result = google_api_request(
      "calendar", "v3", "acl", "delete",
      {
        calendarId: commitment_calendar.calendar_id,
        ruleId: commitment_calendar.acl_id
      }
    ).data
    redirect_to commitment_calendars_path
  end

end
