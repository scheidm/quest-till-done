QuestTillDone::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  #mailers

  config.action_mailer.delivery_method = :smtp
  # Defaults to:
  config.action_mailer.sendmail_settings = {
      address: CONFIG["SMTP_SERVER"],
      port: CONFIG["SMTP_PORT"],
      domain: CONFIG["YOUR_DOMAIN"],
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: ENV["SMTP_USER_NAME"],
      password: ENV["SMTP_USER_PASS"]
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: "no-reply@#{CONFIG["YOUR_DOMAIN"]}"}

  # Raise error if mailer doesnt work

  config.action_mailer.raise_delivery_errors = true


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.encounter_length=60

  # defualt URL
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

end
