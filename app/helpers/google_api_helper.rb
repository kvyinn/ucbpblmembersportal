module GoogleApiHelper

  # Shortcut for accessing the Google API client
  def google_api_client
    @client ||= Google::APIClient.new

    @client.authorization.access_token = cookies[:access_token] || auth_info["credentials"]["token"]

    return @client
  end

  # Wrapper for the Google API client discover and execute method
  def google_api_request(service, version, resources, method, parameters, body=nil, content_type='application/json')
    api_service = google_api_client.discovered_api(service, version)

    api_resource = api_service
    if resources.instance_of? Array
      resources.each { |resource| api_resource = service.send(resource) }
    else
      api_resource = api_resource.send(resources)
    end

    result = google_api_client.execute(
      api_method: api_resource.send(method),
      parameters: parameters,
      body: body,
      headers: { 'Content-Type' => content_type }
    )
  end

  # Accessor for the OmniAuth authorization information
  def auth_info
    request.env["omniauth.auth"]
  end


end