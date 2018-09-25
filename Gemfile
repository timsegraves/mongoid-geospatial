source 'http://rubygems.org'

case version = ENV['MONGOID_VERSION'] || '7'
when 'HEAD'
  gem 'mongoid', github: 'mongodb/mongoid'
when /^7/
  gem 'mongoid', '~> 7.0.0'
when /^6/
  gem 'mongoid', '~> 6.0.0'
when /^5/
  gem 'mongoid', '~> 5.0'
else
  gem 'mongoid', version
end

gemspec

group :development, :test do
  gem 'rake'
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
