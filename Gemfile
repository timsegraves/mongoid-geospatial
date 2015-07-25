source 'http://rubygems.org'

gem 'mongoid', '>=5.0.0.beta'

gemspec # Specify  gem's dependencies in mongoid_geospatial.gemspec

gem 'rake'

group :test do
  gem 'pry'
  gem 'yard'
  gem 'nokogiri'

  gem 'dbf'
  gem 'rgeo'
  gem 'georuby'

  gem 'rspec'

  gem 'rubocop'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec'

  gem 'coveralls', require: false if ENV['CI']
end
