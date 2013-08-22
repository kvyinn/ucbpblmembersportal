# == Schema Information
#
# Table name: tabling_slots
#
#  id         :integer          not null, primary key
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TablingSlot < ActiveRecord::Base
  attr_accessible :end_time, :start_time

  has_many :tabling_slot_members, dependent: :destroy
  has_many :members, through: :tabling_slot_members

end
