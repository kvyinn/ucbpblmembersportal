# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reimbursement do
    member_id 1
    amount 1.5
    details "MyString"
    processed false
  end
end
