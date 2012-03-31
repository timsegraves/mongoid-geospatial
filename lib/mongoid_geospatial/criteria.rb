require 'mongoid_geospatial/criterion/complex'
require 'mongoid_geospatial/criterion/near_spatial'
require 'mongoid_geospatial/criterion/within_spatial'


module Mongoid #:nodoc:
  class Criteria
    delegate :geo_near, :to => :context
  end
end
