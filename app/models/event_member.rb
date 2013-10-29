# == Schema Information
#
# Table name: event_members
#
#  id         :integer          not null, primary key
#  event_id   :string(255)
#  member_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Description
#
# A Member attending an event
#
# == Fields
# - event_id: reference to the event
#
# == Associations
#
# === Belongs to:
# - Member
#
# === Has one:
# - EventPoint
class EventMember < ActiveRecord::Base
  attr_accessible :event_id, :member_id

  belongs_to :member

  has_one :event_points, foreign_key: :event_id, primary_key: :event_id
end
