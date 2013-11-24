# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Quest::Application.initialize!
Quest::Application.config.pomodoro_length=25*60
