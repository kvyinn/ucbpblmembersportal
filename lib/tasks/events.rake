task :dump_events => :environment do
	require "yaml"
	events = Array.new
	Event.all.each do |e|
		events << e
	end
	serialized_list = YAML::dump(events)
	File.open(Rails.root.join('events_dump.yaml'), "w") do |file|
	    file.puts YAML::dump(events)
	end
	puts "saved all your events"
end
task :import_events => :environment do
	require "yaml"
	events = Array.new
	File.open(Rails.root.join('events_dump.yaml'), "r") do |file|
	  events = YAML::load(file)
	end
	# events.each do |event|
	# 	puts "hello there "+event.to_s
	# end
	events.each do |event|
		e = Event.new
		if event and Event.where(name: event.name).length == 0
			# e.name = event.name
			# e.start_time = event.start_time
			# e.end_time = event.end_time
			# e.semester_id = event.semester_id
			e = event
			e.save
			puts "saved an event"
		end
	end
end
task :google_sync => :environment do
	 def google_datetime_fix(datetime)
	    time_string = datetime.date_time ? datetime.date_time.to_s : datetime.date.to_s
	    DateTime.parse(time_string)
	  end
	def process_google_events(events, options={})
	    results = []
	    events.each do |event|
	      start_time = google_datetime_fix(event.start)
	      end_time = google_datetime_fix(event.end)

	      if options[:this_week]
	        start_time = this_week(start_time)
	        end_time = this_week(end_time)
	      end

	      results << {
	        id: event.id,
	        summary: event.summary,
	        start_time: start_time,
	        end_time: end_time,
	      }
	    end

	    return results.sort_by {|event| event[:start_time]}
	  end
	# Initialize the client & Google+ API
    # require 'google/api_client'
    client = Google::APIClient.new
    service = client.discovered_api('calendar','v3')
    # Initialize OAuth 2.0 client
    client.authorization.client_id = "158145275272-lj3m0j741dj9fp50rticq48vtrfu59jj.apps.googleusercontent.com"
    client.authorization.client_secret = "XvvJaFO2t2lD0mEzNdya6NgT"
    # client.authorization.redirect_uri = 'http://localhost:3000/auth/google_oath2/callback'

    # client.authorization.scope = 'https://www.googleapis.com/auth/userinfo.email
    #         https://www.googleapis.com/auth/calendar
    #         https://www.googleapis.com/auth/plus.login'

    # Request authorization
    # redirect_uri = client.authorization.authorization_uri

    # Wait for authorization code then exchange for token
    # client.authorization.code = '....'
    # client.authorization.fetch_access_token!
    calendarId = '8bo2rpf4joem2kq9q2n940p1ss@group.calendar.google.com'
    client.authorization.access_token = '29.1.AADtN_XrNtFHYhP7DUvVh6vdqdKL0FOJWzHkNrlMmhpsz9ZsY0j9fE1p5FKTEHworL3-'
    # Make an API call
    result = client.execute(
      api_method: service.events.list,
      parameters: {
        calendarId: calendarId,
      },
      headers: { 'Content-Type' => 'application/json' }
    )
    puts result.data
    puts "that was the resulting data"
    if result.data.error
    	puts "it seems there was an error"
    	puts result.data.error
    end
    if result.data.data
    	puts "there was another layer fuck"
    	puts result.data.data
    end
    if result.data.error.errors
    	puts "ok errorers"
    	puts result.data.error.errors
    end
    # all_events = result.data.items
    # all_events = process_google_events(all_events)
    # all_events.each do |e|
    #   event = Event.new
    #   if Event.where(google_id: e[:id]).length != 0
    #     event = Event.where(google_id: e[:id]).first
    #   end
    #   if e[:start_time] and e[:end_time]
    #     event.google_id = e[:id]
    #     event.start_time = e[:start_time]
    #     event.end_time = e[:end_time]
    #     event.name = e[:summary]
    #     event.save
    #   end
    # end
    puts "Done adding all events"
end

