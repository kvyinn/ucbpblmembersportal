# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :committee_member do
    member_id 1
    committee_id 1
    committee_member_type 1
  end
end
