class Event < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :description, :semester_id, :google_id
  belongs_to :semester
  has_one :event_points, dependent: :destroy
  has_many :event_members, dependent: :destroy
end
