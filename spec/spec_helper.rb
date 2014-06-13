require 'simplecov'
SimpleCov.start

require 'webmock/rspec'

if ENV['CI']
  WebMock.disable_net_connect!(allow: %w(codeclimate.com))
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'morito'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
