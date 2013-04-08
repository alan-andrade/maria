require 'rubygems'
require 'spork'
require 'pry'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../spec/dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  FileControl::Test.setup
  Git::Test.setup

  Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    config.include FileControl::TestHelpers
    config.before(:each){ @routes = Maria::Engine.routes }
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
  end
end

Spork.each_run do
end

