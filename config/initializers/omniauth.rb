Rails.application.config.middleware.use OmniAuth::Builder do
  CLIENT_ID = "296875203176.apps.googleusercontent.com"
  CLIENT_SECRET = "Mf0mtCVzYBKRXvISeWrJw2Dz"
  provider :google_oauth2, CLIENT_ID, CLIENT_SECRET, {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email
            https://www.googleapis.com/auth/calendar
            https://www.googleapis.com/auth/plus.login',
    redirect_uri:'http://localhost/auth/google_oauth2/callback'
  }
end
