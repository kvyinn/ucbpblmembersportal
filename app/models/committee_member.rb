# == Schema Information
#
# Table name: committee_members
#
#  id                       :integer          not null, primary key
#  member_id                :integer
#  committee_id             :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  committee_member_type_id :integer
#

class CommitteeMember < ActiveRecord::Base
  attr_accessible :committee_id, :committee_member_type_id, :member_id

  belongs_to :committee_member_type
  belongs_to :member
  belongs_to :committee
end
