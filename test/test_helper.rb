$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'vcr'
require 'pry'

require 'clerkapp'

ENV['CLERK_URL'] = 'http://username:d1e79306367b4c5467bfb9e788fcf748@localhost:9292'

VCR.configure do |c|
  c.cassette_library_dir = File.join("test", "vcr_cassettes")
  c.hook_into :webmock
end
