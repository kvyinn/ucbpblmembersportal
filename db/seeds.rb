# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development?
  100.times { FactoryGirl.create(:member) }
  10.times { FactoryGirl.create(:committee) }
  5.times { FactoryGirl.create(:committee_member_type) }

  Member.all.each do |member|
    committee_member = member.committee_members.create!(
      committee_id: Committee.first(offset: rand(Committee.count)).id,
      committee_member_type_id: CommitteeMemberType.first(offset: rand(CommitteeMemberType.count)).id,
    )
  end
end

statuses = [:available, :attending, :attended, :late, :missed, :make_up]
statuses.each { |status| Status.create!(name: status) }
