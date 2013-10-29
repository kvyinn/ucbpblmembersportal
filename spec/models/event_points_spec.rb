# == Schema Information
#
# Table name: event_points
#
#  id         :integer          not null, primary key
#  event_id   :string(255)      not null
#  value      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe EventPoints do
  pending "add some examples to (or delete) #{__FILE__}"
end
