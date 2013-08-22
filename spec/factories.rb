FactoryGirl.define do

  factory :member do
    provider { Faker::Lorem.sentence(3) }
    uid { rand(1000) }
    name { Faker::Name.name }
  end

end
