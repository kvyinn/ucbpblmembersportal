class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include GoogleApiHelper
  include CalendarsHelper
  include EventsHelper
  include CommitmentCalendarsHelper
  include MembersHelper
  include TablingSlotsHelper
end
