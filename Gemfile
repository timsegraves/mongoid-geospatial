source 'http://rubygems.org'
gemspec # Specify  gem's dependencies in mongoid_geospatial.gemspec

gem 'rake'
gem 'mongoid' #, github: 'mongoid/mongoid'

gem 'pry'
gem 'yard'

gem 'dbf'
gem 'rspec'
gem 'nokogiri'
gem 'rgeo'
gem 'georuby'

if ENV['CI']
  gem 'coveralls', require: false
else
  gem 'rubocop'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec'
  # gem 'rb-fsevent'
end
