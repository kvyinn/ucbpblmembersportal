# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  member_id  :integer          not null
#  value      :integer          not null
#  details    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Point do
  pending "add some examples to (or delete) #{__FILE__}"
end
