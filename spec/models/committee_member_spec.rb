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

require 'spec_helper'

describe CommitteeMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
