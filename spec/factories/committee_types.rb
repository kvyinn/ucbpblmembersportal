# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :committee_type do
    name { Faker::Lorem.word }
    sequence(:tier) { |n| n }
  end

end
