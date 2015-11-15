# This file is used by Rack-based servers to start the application.
if ENV['RACK_ENV'] != 'production' then
  require 'rack-livereload'
  use Rack::LiveReload
end
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

