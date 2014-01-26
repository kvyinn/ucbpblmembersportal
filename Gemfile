source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.12'

gem 'mysql2'
gem 'pg', '0.16.0' #version

# david added these
gem "activeadmin", '0.6.2' #version

gem 'will_paginate', '~> 3.0'
gem 'mercury-rails'
gem 'fb_graph'
gem "koala", "~> 1.8.0rc1"
gem 'omniauth-facebook'
# end of david added these

group :production do
  gem 'rails_12factor', '0.0.2' #version
end

group :assets do
  gem 'sass-rails',   '~> 3.2.6' #changed from 3.2.3
  gem 'coffee-rails', '~> 3.2.2' #changed from 3.2.1
  gem 'coffee-script-source', '~> 1.4.0'
  gem 'bootstrap-sass', '2.3.2.1' #version
  gem 'uglifier', '2.1.2'#'>= 1.0.3'
end

group :test do
  gem 'capybara', '~> 1.1.2'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.14'
  # gem 'thin'
end

group :development do
  gem 'annotate'
  gem 'quiet_assets'
  gem 'sqlite3'
end

# gem 'jquery-rails'
gem 'jquery-rails', '~> 2.3.0'
gem 'factory_girl_rails', '~> 4.0.0'
gem 'faker', '1.2.0' #added version
gem 'chronic', '0.10.2' #added version

# gem 'rjb'
# heroku_java_home = '/usr/lib/jvm/java-6-openjdk'
# ENV['JAVA_HOME'] = heroku_java_home if Dir.exist?(heroku_java_home)

gem 'nifty-generators', '0.4.6' #added version
gem 'google-api-client', :require => 'google/api_client'
gem 'omniauth', '1.1.0'
gem 'omniauth-google-oauth2', :git => 'https://github.com/zquestz/omniauth-google-oauth2.git'
gem "devise", '3.2.2' #added version