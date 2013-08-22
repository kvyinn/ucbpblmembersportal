# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :committee do
    name { Faker::Lorem.word }
    abbr { Faker::Lorem.characters(2).upcase }
    committee_type
  end

end
