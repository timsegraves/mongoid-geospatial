source 'http://rubygems.org'

gemspec # Specify  gem's dependencies in mongoid_geospatial.gemspec

gem 'pry'
gem 'rake'
gem 'yard'
gem 'mongoid' #, github: 'mongoid/mongoid'

gem 'nokogiri'
gem 'dbf'
gem 'rgeo'
gem 'georuby'

if ENV['CI']
  gem 'coveralls', require: false
else
  gem 'rspec'
  gem 'rubocop'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec'
end
