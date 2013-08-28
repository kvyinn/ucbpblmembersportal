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
    redirect_to google_signin_url if current_member.nil?
  end
end
