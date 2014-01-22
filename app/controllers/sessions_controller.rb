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
    puts result.data
    if result.data.error
      puts "there was an ERROR"
      puts result.data.error
    else
      puts "there was no ERROR you should go on"
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

end
