class Commitment < ActiveRecord::Base
  attr_accessible :end_time, :member_id, :start_time, :summary

  belongs_to :member

  # TEMPORARY fix for all day events
  def self.this_week(datetime)
    Chronic.parse("#{datetime.strftime("%H:%M")} this #{datetime.strftime("%A")}").to_datetime
  end
end
