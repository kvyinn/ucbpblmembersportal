class Semester < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date
  # has_many :members, through: :semester_members
  # has_many :event_points
  # has_many :committee_members
end
