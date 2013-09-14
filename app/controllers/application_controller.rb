class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include GoogleApiHelper
  include CalendarsHelper
  include EventsHelper
  include CommitmentCalendarsHelper
  include MembersHelper
  include TablingSlotsHelper
  include CommitmentsHelper

  before_filter :signed_on_to_google

  def signed_on_to_google
    if current_member
      result = google_api_request( 'plus', 'v1', 'people', 'get', { userId: current_member.uid })
      if result.status != 200
        sign_out
        redirect_to google_signin_url, notice: "Your session has timed out"
      else
        current_member.name = result.data.display_name
        current_member.save
      end
    else
      redirect_to google_signin_url
    end
  end

  def admin_member
    redirect_to root_path, notice: "You are not authorized to do that" if !current_member.admin?
  end

  # Controller Helpers

  # Roughly the first day of instruction for fall
  # Basically, find the last Thursday of August
  def beginning_of_fall_semester
    week = 4

    date = Chronic.parse("#{week}th thursday last august")
    while date
      week += 1
      date = Chronic.parse("#{week}th thursday last august")
    end

    Chronic.parse("#{week - 1}th thursday last august").to_datetime
  end

  # Get the date of the next indicated weekday
  def date_of_next(day)
    date  = Date.parse(day)
    delta = date > Date.today ? 0 : 7
    date + delta
    Chronic.parse("next #{day}").to_datetime
  end

  def to_datetime(day, time)
    hour = time.to_i/100

    datetime = date_of_next(day).change(offset: "-0700") + hour.hours
    return datetime
  end

end
