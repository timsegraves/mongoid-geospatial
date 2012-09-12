require 'rgeo'
require 'mongoid'
require 'active_support/core_ext/string/inflections'
require 'active_support/concern'
require 'mongoid_geospatial/contextual/mongo'
require 'mongoid_geospatial/criteria'
require 'mongoid_geospatial/extensions/symbol'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'
require 'mongoid_geospatial/field_option'

%w{point polygon line_string}.each do |type|
  require "mongoid_geospatial/fields/#{type}"
end

require 'mongoid_geospatial/finders'
require 'mongoid_geospatial/geospatial'
