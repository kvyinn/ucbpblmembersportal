# == Schema Information
#
# Table name: committees
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  abbr              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  committee_type_id :integer
#

# == Description
#
# A committee, consisting of a group of Members.
#
# Has a type that acts as a classification/tiering between committees.
#
# == Fields
# - name: name of the committee
# - abbr: the committee's abbreviation
#
# == Associations
#
# === Belongs to:
# - CommitteeType
#
# === Has many:
# - CommitteeMember
# - Member
class Committee < ActiveRecord::Base
  attr_accessible :name, :committee_type_id

  belongs_to :committee_type

  has_many :committee_members, dependent: :destroy
  has_many :members, through: :committee_members

  # Show the committee's total points.
  def points
    sum = 0
    self.committee_members.each do |committee_member|
      if committee_member.committee_member_type == CommitteeMemberType.cm or
          committee_member.committee_member_type == CommitteeMemberType.chair

        sum += committee_member.member.total_points
      end
    end

    return sum
  end
end
