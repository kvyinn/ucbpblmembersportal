# goals:
# each committee member has old semester id
# each (old) event has old semester id (sync afterwards -- sync adds new semester to new events)
# event_points have correct event_id
# event_members have correct event_id
task :update_all_members => :environment do
	Member.all.each do |mem|
		begin
			mem.update_from_old_member
		rescue
			p "error with"
			p mem.name
		end
	end
end
task :update_event_semesters => :environment do
	Event.all.each do |e|
		spring = Semester.where(name: "Spring 2014").first
		fall = Semester.where(name: "Fall 2013").first
		previous = Semester.where(name: "Previous Semesters").first
		if e.start_time > spring.start_date
			spring.events << e
		elsif e.start_time > fall.start_date
			fall.events << e
		else
			previous.events << e
		end
		if e.save
			puts "saved an event"
		else
			puts "save failed"
		end
	end
end
task :add_semester_ids => :environment do
	CommitteeMember.all.each do |cm|
		cm.semester_id = 1 #Semester.current_semester.id
		cm.save
	end
	puts "converted cms"
end

task :correct_event_ids => :environment do
	EventPoints.all.each do |ep|
		google_id = ep.event_id
		puts google_id
		events = Event.where(google_id: google_id)
		if events.length != 0
			puts "found a match"
			ep.event_id = events.first.id
			ep.google_id = google_id
			ep.save
		end
		if Event.where(id: ep.event_id).length > 0
			puts "it was already converted"
		end
	end
	puts "converted ep"
	EventMember.all.each do |em|
		google_id = em.event_id
		puts google_id
		events = Event.where(google_id: google_id)
		if events.length != 0
			events.first.event_members << em
			em.google_id = google_id
			em.save
		end
	end
	puts "converted em"
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