source 'http://rubygems.org'

gem 'mongoid', '>=5.0.0'

gemspec # Specify  gem's dependencies in mongoid_geospatial.gemspec

gem 'rake'

group :development, :test do
  gem 'pry'
  gem 'yard'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec'
end

group :test do
  gem 'nokogiri'
  gem 'dbf'
  gem 'rgeo'
  gem 'georuby'
  gem 'rspec'
  gem 'coveralls', require: false if ENV['CI']
  gem 'mongoid-danger', '~> 0.1.0', require: false
  gem 'rubocop', '0.45.0'
end
