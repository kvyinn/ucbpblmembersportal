class Reimbursement < ActiveRecord::Base
  attr_accessible :amount, :details, :member_id, :processed

  belongs_to :member
end
