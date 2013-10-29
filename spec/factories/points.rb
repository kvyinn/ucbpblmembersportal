# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :point do
    member_id 1
    value 1
    details "MyString"
  end
end
