# == Schema Information
#
# Table name: commitment_calendars
#
#  id          :integer          not null, primary key
#  member_id   :integer
#  calendar_id :string(255)
#  acl_id      :string(255)
#  tag         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe CommitmentCalendar do
  pending "add some examples to (or delete) #{__FILE__}"
end
