# require 'pry'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

MODELS = File.join(File.dirname(__FILE__), "models")
SUPPORT = File.join(File.dirname(__FILE__), "support")
$LOAD_PATH.unshift(MODELS)
$LOAD_PATH.unshift(SUPPORT)

if ENV["CI"]
  #require "simplecov"
  require "coveralls"
  Coveralls.wear!
  #SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  #SimpleCov.start do
  #  add_filter "spec"
  #end
end

require "mongoid"
# require "mocha"
require "rspec"
require "mongoid_geospatial"

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["MONGOID_SPEC_HOST"] ||= "localhost"
ENV["MONGOID_SPEC_PORT"] ||= "27018"

# These are used when creating any connection in the test suite.
HOST = ENV["MONGOID_SPEC_HOST"]
PORT = ENV["MONGOID_SPEC_PORT"].to_i

LOGGER = Logger.new($stdout)

if RUBY_VERSION >= '1.9.2'
  YAML::ENGINE.yamler = 'syck'
end

puts "Running with Mongoid v#{Mongoid::VERSION}"

Mongoid.configure do |config|
  config.connect_to('mongoid_geo_test')
end

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  autoload name.camelize.to_sym, name
end

Dir[ File.join(SUPPORT, "*.rb") ].each { |file| require File.basename(file) }

def bson_object_id_class
  Moped::BSON::ObjectId
end

RSpec.configure do |config|
  # config.mock_with(:mocha)

  config.before(:each) do
    Mongoid.purge!
  end
end
