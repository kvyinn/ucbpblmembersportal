class Event < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :description, :semester_id, :google_id
  belongs_to :semester, foreign_key: :semester_id
  has_one :event_points #, dependent: :destroy
  has_many :event_members #, dependent: :destroy

  def points
  	points = EventPoints.where(event_id: self.id)
  	if points.length != 0
  		return points.first.value
  	end
  	return 0
  end

  def attendees
  	attendees = Array.new
  	event_members = EventMember.where(event_id: self.id)
  	event_members.each do |em|
  		attendees << Member.find(em.member_id)
  	end
  	return attendees
  end

end
