# == Schema Information
#
# Table name: reimbursements
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  amount     :float
#  details    :string(255)
#  processed  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Reimbursement do
  pending "add some examples to (or delete) #{__FILE__}"
end
