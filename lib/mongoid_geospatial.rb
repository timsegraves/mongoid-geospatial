require 'mongoid'
require 'active_support/core_ext/string/inflections'
require 'active_support/concern'
require 'mongoid_geospatial/extensions/core_ext'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'
require 'mongoid_geospatial/field_option'

%w{point polygon line_string}.each do |type|
  require "mongoid_geospatial/fields/#{type}"
end

require 'mongoid_geospatial/geospatial'
