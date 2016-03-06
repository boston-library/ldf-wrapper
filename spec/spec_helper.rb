require 'simplecov'
SimpleCov.start

require 'rspec/its'
require 'ldfwrapper'

RSpec.configure do |config|
end

unless ENV.select { |k,v| k =~ /TEST_JETTY_PORT/ }.empty?
  TEST_JETTY_PORTS = ENV.select { |k,v| k =~ /TEST_JETTY_PORT/ }.sort_by { |k,v| k }.map { |k,v| v }
else
  TEST_JETTY_PORTS = [8985, 8986,9999,8888]
end
