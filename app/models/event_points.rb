# == Schema Information
#
# Table name: event_points
#
#  id         :integer          not null, primary key
#  event_id   :string(255)      not null
#  value      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Description
#
# A mapping of an event to some point value.
#
# == Fields
# - event_id: reference to an event
# - value: point value
class EventPoints < ActiveRecord::Base
  attr_accessible :event_id, :value

  validates :event_id, :value, presence: true
  validates :value, numericality: true
end
