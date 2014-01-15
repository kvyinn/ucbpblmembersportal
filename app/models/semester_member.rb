class SemesterMember < ActiveRecord::Base
  attr_accessible :semester_id, :member_id
  belongs_to :member
  belongs_to :semester
end
