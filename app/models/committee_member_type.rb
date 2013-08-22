# == Schema Information
#
# Table name: committee_member_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tier       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CommitteeMemberType < ActiveRecord::Base
  attr_accessible :name, :tier

  has_many :committee_members
  has_many :committees, through: :committee_members
  has_many :members, through: :committee_members
end
