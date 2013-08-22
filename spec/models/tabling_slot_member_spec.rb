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

require 'spec_helper'

describe TablingSlotMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
