# == Schema Information
#
# Table name: tabling_slot_members
#
#  id              :integer          not null, primary key
#  member_id       :integer
#  tabling_slot_id :integer
#  status_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TablingSlotMember < ActiveRecord::Base
  attr_accessible

  belongs_to :member
  belongs_to :tabling_slot
  belongs_to :status

  def set_status_to(status)
    self.status = Status.where(name: status).first
  end
end
