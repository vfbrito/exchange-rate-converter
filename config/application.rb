require 'rubygems'
require 'bundler'
require 'sinatra/base'
require 'redis'
require 'rack/conneg'

Bundler.require

configure do
  set :server, :puma
  set :bind, '0.0.0.0'
end
