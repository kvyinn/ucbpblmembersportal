class Event < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :description, :semester_id, :google_id
  belongs_to :semester, foreign_key: :semester_id
  has_one :event_points #, dependent: :destroy
  has_many :event_members #, dependent: :destroy
  has_many :blog_events
  has_many :posts, :through => :blog_events
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

  def attendance_rate(committee)
    attendees = self.attendees
    total_cms = committee.cms.length
    count = 0
    for a in attendees
      if a.current_committee == committee
        count = count + 1
      end
    end
    return [count, total_cms, (count.to_f/total_cms)]
  end
end
