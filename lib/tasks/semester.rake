task :change_semester_points => :environment do
  EventPoints.all.each do |event_points|
    event_points.semester_id = 1
    event_points.save
  end
end

task :change_semester_event => :environment do
  EventMember.all.each do |em|
    em.semester_id = 1
    em.save
  end
end