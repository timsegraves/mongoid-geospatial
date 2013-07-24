source 'http://rubygems.org'
gemspec # Specify  gem's dependencies in mongoid_geospatial.gemspec

gem 'rake'

group :development do
  gem 'pry'
  gem "yard"
  # gem 'fuubar'
end

group :test do
  gem 'dbf'
  gem 'rspec'
  gem 'nokogiri'
  gem 'rgeo'
  gem 'georuby'

  if ENV["CI"]
    gem "coveralls", require: false
    gem "yard"
  else
    gem "guard"
    gem "guard-rspec"
    gem "rb-fsevent"
  end
end
