require 'mongoid_geospatial/geospatial/core_ext'
require 'mongoid_geospatial/geospatial/geo_near_results'

module Mongoid
  module Geospatial
    LNG_SYMBOLS = [:x, :lon, :long, :lng, :longitude]
    LAT_SYMBOLS = [:y, :lat, :latitude]

    EARTH_RADIUS_KM = 6371 # taken directly from mongodb

    EARTH_RADIUS = {
      :km => EARTH_RADIUS_KM,
      :m  => EARTH_RADIUS_KM*1000,
      :mi => EARTH_RADIUS_KM*0.621371192, # taken directly from mongodb
      :ft => EARTH_RADIUS_KM*5280*0.621371192,
      :sm => EARTH_RADIUS_KM*0.53995680345572 # sea mile
    }

    RAD_PER_DEG = Math::PI/180
    mattr_accessor :lng_symbols
    @@lng_symbols = LNG_SYMBOLS.dup

    mattr_accessor :lat_symbols
    @@lat_symbols = LAT_SYMBOLS.dup

    mattr_accessor :earth_radius
    @@earth_radius = EARTH_RADIUS.dup

    mattr_accessor :paginator
    @@paginator = :array

    mattr_accessor :default_per_page
    @@default_per_page = 25

    # mattr_accessor :spherical_distance_formula
    # @@spherical_distance_formula = :n_vector

  end
end
