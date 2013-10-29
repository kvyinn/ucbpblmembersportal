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

require 'spec_helper'

describe Committee do
  pending "add some examples to (or delete) #{__FILE__}"
end
