# goals:
# each committee member has old semester id
# each (old) event has old semester id (sync afterwards -- sync adds new semester to new events)
# event_points have correct event_id
# event_members have correct event_id
task :add_semester_ids => :environment do
	CommitteeMember.all.each do |cm|
		cm.semester_id = 1
	end
	Event.all.each do |event|
		if event.start_time < DateTime.now
			event.semester_id = 1
		else
			event.semster_id = 2
		end
	end
end

task :correct_event_ids => :environment do
	EventPoints.each do |ep|
		google_id = ep.event_id
		events = Event.where(google_id: google_id)
		if events.length != 0
			ep.event_id = events.first.id
			ep.google_id = google_id
			em.save
		else
			ep.destroy
		end
	end
	EventMember.each do |em|
		google_id = em.event_id
		events = Event.where(google_id: google_id)
		if events.length != 0
			em.event_id = events.first.id
			em.google_id = google_id
		else
			em.destroy
			em.save
		end
	end
end

# task :change_semester_points => :environment do
#   EventPoints.all.each do |event_points|
#     event_points.semester_id = 1
#     event_points.save
#   end
# end

# task :change_semester_event => :environment do
#   EventMember.all.each do |em|
#     em.semester_id = 1
#     em.save
#   end
# end