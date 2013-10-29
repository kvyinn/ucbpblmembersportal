# == Schema Information
#
# Table name: event_members
#
#  id         :integer          not null, primary key
#  event_id   :string(255)
#  member_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe EventMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
