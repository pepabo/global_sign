$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'global_sign'

require 'dotenv'
require 'vcr'
require 'pry'

Dotenv.load

GlobalSign.configure do |configuration|
  configuration.user_name = ENV['USER_NAME']
  configuration.password  = ENV['PASSWORD']
  configuration.endpoint  = 'https://test-gcc.globalsign.com/kb/ws/v1'
end

VCR.configure do |configuration|
  configuration.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  configuration.hook_into :webmock
  configuration.filter_sensitive_data('[USER_NAME]') { ENV['USER_NAME'] }
  configuration.filter_sensitive_data('[PASSWORD]') {  ENV['PASSWORD'] }
end
