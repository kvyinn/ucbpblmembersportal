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

  # Filters

  # App-wide filter for checking if a user is signed in via Google
  def signed_on_to_google
    if current_member
      result = google_api_request( 'plus', 'v1', 'people', 'get', { userId: current_member.uid })
      if result.status != 200
        sign_out
        session[:return_to] = request.url if request.get?
        redirect_to google_signin_url, notice: "Your session has timed out"
      else
        current_member.name = result.data.display_name
        current_member.save
      end
    else
      redirect_to google_signin_url
    end
  end

  # Redirect to home if attempting an admin-only action.
  def admin_member
    redirect_to root_path, notice: "You are not authorized to do that" if !current_member.admin?
  end

  # Redirect to home if attempting an officer-only action.
  def officer
    redirect_to root_path, notice: "You are not authorized to do that" if !current_member.officer?
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
    Chronic.parse("0 next #{day}").to_datetime
  end

  # Date of the tabling start day
  def tabling_start
    if DateTime.now.cwday > 5 # If past Friday
      Chronic.parse("0 this monday")
    elsif DateTime.now.cwday == 1 # If Monday
      Chronic.parse("0 today")
    else
      Chronic.parse("0 last monday")
    end
  end

  # Date of ending tabling
  def tabling_end(length=5)
    tabling_start + length.days
  end

  def to_datetime(day, time)
    hour = time.to_i/100

    datetime = date_of_next(day).change(offset: "-0700") + hour.hours
    return datetime
  end

  # TEMPORARY fix for all day events
  def this_week(datetime)
    Chronic.parse("#{datetime.strftime("%H:%M")} this #{datetime.strftime("%A")}").to_datetime
  end
end
