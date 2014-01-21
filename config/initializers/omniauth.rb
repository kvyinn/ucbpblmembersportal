Rails.application.config.middleware.use OmniAuth::Builder do
  # CLIENT_ID = "296875203176.apps.googleusercontent.com"
  # CLIENT_SECRET = "Mf0mtCVzYBKRXvISeWrJw2Dz"
  # davids
  CLIENT_ID = "158145275272-lj3m0j741dj9fp50rticq48vtrfu59jj.apps.googleusercontent.com"
  CLIENT_SECRET = "XvvJaFO2t2lD0mEzNdya6NgT"
  provider :google_oauth2, CLIENT_ID, CLIENT_SECRET, {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email
            https://www.googleapis.com/auth/calendar
            https://www.googleapis.com/auth/plus.login',
    redirect_uri:'http://ucbpblmp-staging.herokuapp.com/auth/google_oauth2/callback'
    # redirect_uri: 'http://localhost:3000/auth/google_oath2/callback'
  }
end
