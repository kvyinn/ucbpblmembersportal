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

# A reimbursement record.
#
# == Fields
# - amount: the amount in dollars
# - details: a description of what the reimbursement is for
# - processed: marks the reimbursement as processed
#
# == Associations
#
# === Belongs to:
# - Member
class Reimbursement < ActiveRecord::Base
  attr_accessible :amount, :details, :member_id, :processed

  belongs_to :member
end
