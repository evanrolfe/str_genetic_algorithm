require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'rspec/its'
require 'simplecov'
require 'pry'
require 'genetic_algorithm'

SimpleCov.start

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.color = true
end
