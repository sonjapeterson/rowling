require 'rowling'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'vcr'
require 'minitest-vcr'
require 'webmock'
require 'httparty'
require 'pry'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
end
MinitestVcr::Spec.configure!
