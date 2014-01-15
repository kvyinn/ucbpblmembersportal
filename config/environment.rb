# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ucbpblmembersportal::Application.initialize!

# RJB stuff
ENV['JAVA_HOME'] = "/usr/lib/jvm/java-7-openjdk-amd64"

ENV['SSL_CERT_FILE'] = "c:/users/david/desktop/rails/cacert.pem"
