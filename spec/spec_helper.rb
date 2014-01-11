require 'bundler'

Bundler.require(:test)

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Warden::Test::Helpers
end
