# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_point, :class => 'EventPoints' do
    event_id "MyString"
    value 1
  end
end
