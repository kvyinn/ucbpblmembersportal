# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Description
# A tabling status.
# See db/seeds.rb for the default values
#
# == Associations
#
# === Has many:
# - TablingSlotMember
class Status < ActiveRecord::Base
  attr_accessible :name

  has_many :tabling_slot_members
end
