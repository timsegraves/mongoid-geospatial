source 'http://rubygems.org'
gemspec # Specify  gem's dependencies in mongoid_geospatial.gemspec

gem 'rake'
gem 'mongoid' #, github: 'mongoid/mongoid'

group :development do
  gem 'pry'
  gem 'yard'
end

group :test do
  gem 'dbf'
  gem 'rspec'
  gem 'nokogiri'
  gem 'rgeo'
  gem 'georuby'

  if ENV['CI']
    gem 'coveralls', require: false
    gem 'yard'
  else
    gem 'rubocop'
    gem 'fuubar'
    gem 'guard'
    gem 'guard-rubocop'
    gem 'guard-rspec'
    # gem 'rb-fsevent'
  end
end
