source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.12'

gem 'mysql2'
gem 'pg'

# david added these
gem "activeadmin"


# end of david added these

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass'
  gem 'uglifier', '>= 1.0.3'
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
gem 'faker'
gem 'chronic'

gem 'rjb'
heroku_java_home = '/usr/lib/jvm/java-6-openjdk'
ENV['JAVA_HOME'] = heroku_java_home if Dir.exist?(heroku_java_home)

gem 'nifty-generators'
gem 'google-api-client', :require => 'google/api_client'
gem 'omniauth', '1.1.0'
gem 'omniauth-google-oauth2', :git => 'https://github.com/zquestz/omniauth-google-oauth2.git'
