require 'rgeo'
require 'mongoid'
require 'active_support/core_ext/string/inflections'
require 'active_support/concern'
require 'mongoid_geospatial/contexts/mongo'
require 'mongoid_geospatial/criteria'
require 'mongoid_geospatial/extensions/symbol'
require 'mongoid_geospatial/field_option'

fields_path = 'mongoid_geospatial/fields' + (Mongoid::VERSION > '3' ? '' : '/mongoid2')

%w{point polygon line_string}.each do |type|
  require "#{fields_path}/#{type}"
end

require 'mongoid_geospatial/finders'
require 'mongoid_geospatial/geospatial'

