class SessionsController < ApplicationController

  skip_before_filter :signed_on_to_google

  def google_api_events(parameters)
    client = Google::APIClient.new
    if cookies[:access_token]
      puts "YEAH I GOT AN ACCESS TOKEN"
    else
      puts "NO ACCESS TOKEN SHIIT"
    end
    calendarId = '8bo2rpf4joem2kq9q2n940p1ss@group.calendar.google.com'
    client.authorization.access_token = cookies[:access_token] || auth_info["credentials"]["token"]
    puts client.authorization.access_token
    puts "THAT WAAS THE ACEES TOKENN"
    service = client.discovered_api('calendar','v3')
    result = client.execute(
      api_method: service.events.list,
      parameters: {
        calendarId: calendarId,
      },
      headers: { 'Content-Type' => 'application/json' }
    )
    all_events = process_google_events(result.data.items)
    all_events.each do |e|
      event = Event.new
      if Event.where(google_id: e[:id]).length != 0
        event = Event.where(google_id: e[:id]).first
      end
      if e[:start_time] and e[:end_time]
        event.google_id = e[:id]
        event.start_time = e[:start_time]
        event.end_time = e[:end_time]
        event.name = e[:summary]
        event.save
      end
    end
  end

  def create
    @result = google_api_request('plus', 'v1', 'people', 'get', { userId: auth_info["uid"] } )
    cookies[:access_token] = auth_info["credentials"]["token"]
    cookies[:refresh_token] = auth_info["credentials"]["refresh_token"]

    member = Member.initialize_with_omniauth(auth_info["provider"], auth_info["uid"])
    member.name = @result.data.display_name
    if cookies[:sync_with_google]
      puts "trying to sync with google"
      events = google_api_events("hello")
      cookies[:sync_with_google] = nil
      # if events.data.error
      #   puts "THERE IS AN ERROR OMG"
      #   puts events.data.error
      # else
      #   puts "no errors youre in the clear"
      # end
    end
    if member.save
      cookies[:remember_token] = member.remember_token
      if session[:return_to]
        redirect_to session[:return_to]
        session.delete(:return_to)
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    cookies[:remember_token] = nil
    current_member = nil;
    redirect_to "https://accounts.google.com/logout"
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

  def google_datetime_fix(datetime)
    time_string = datetime.date_time ? datetime.date_time.to_s : datetime.date.to_s
    DateTime.parse(time_string)
  end

end
