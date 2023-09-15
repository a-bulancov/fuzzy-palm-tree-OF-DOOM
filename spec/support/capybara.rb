# frozen_string_literal: true

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument '--no-sandbox'
  options.add_argument '--disable-dev-shm-usage'

  Capybara::Selenium::Driver.new app, browser: :chrome, options: options,
                                 clear_local_storage: true,
                                 clear_session_storage: true
end

Capybara.javascript_driver = :headless_chrome
Capybara.server = :webrick

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :rack_test }
  config.before(:each, type: :system, js: true) { driven_by :headless_chrome }
end
