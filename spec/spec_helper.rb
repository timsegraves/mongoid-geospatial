require 'pry'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

MODELS = File.join(File.dirname(__FILE__), "models")
SUPPORT = File.join(File.dirname(__FILE__), "support")
$LOAD_PATH.unshift(MODELS)
$LOAD_PATH.unshift(SUPPORT)

require "mongoid"
require "mocha"
require "rspec"
require "mongoid_geospatial"

LOGGER = Logger.new($stdout)

if RUBY_VERSION >= '1.9.2'
  YAML::ENGINE.yamler = 'syck'
end

Mongoid.configure do |config|
  name = "mongoid_geospatial_test"
  config.master = Mongo::Connection.new.db(name)
  config.logger = nil
  config.allow_dynamic_fields = true
end

Dir[ File.join(MODELS, "*.rb") ].sort.each { |file| require File.basename(file) }
Dir[ File.join(SUPPORT, "*.rb") ].each { |file| require File.basename(file) }

RSpec.configure do |config|
  config.mock_with(:mocha)

  config.after(:suite) { Mongoid.purge! }
  config.after(:each) do
    Mongoid.database.collections.each do |collection|
      unless collection.name =~ /^system\./
        collection.remove
      end
    end
  end

  # We filter out the specs that require authentication if the database has not
  # had the mongoid user set up properly.
  user_configured = Support::Authentication.configured?
  warn(Support::Authentication.message) unless user_configured

  config.filter_run_excluding(:config => lambda { |value|
    return true if value == :user && !user_configured
  })
end
