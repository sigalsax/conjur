require 'capybara/rails'
require 'capybara-screenshot/cucumber'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.run_server = false
Capybara.app_host = ENV['CAPYBARA_APP_HOST'] || 'https://localhost'
Capybara.raise_server_errors= true
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = :keep_last_run

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
      :js_errors => true,
      :phantomjs_logger => File.open('./tmp/cuke-phantomjs_log.txt', 'w'),
      :phantomjs_options => ['--ssl-protocol=tlsv1.2', '--load-images=no', '--disk-cache=false'],
      :inspector => true
      # :debug => true
      # timeout: 60
  })
end

Capybara.default_max_wait_time = 10
