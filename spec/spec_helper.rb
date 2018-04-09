require 'rack/test'
require 'rspec'
require './config/application'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app
    ExchangeRateConverterApp
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
end

