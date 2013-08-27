class Commitment < ActiveRecord::Base
  attr_accessible :end_time, :member_id, :start_time, :summary

  belongs_to :member
end
