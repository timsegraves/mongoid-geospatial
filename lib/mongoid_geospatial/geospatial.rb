require 'mongoid_geospatial/geospatial/core_ext'
require 'mongoid_geospatial/geospatial/geo_near_results'

module Mongoid
  module Geospatial
    extend ActiveSupport::Concern

    LNG_SYMBOLS = [:x, :lon, :long, :lng, :longitude]
    LAT_SYMBOLS = [:y, :lat, :latitude]

    EARTH_RADIUS_KM = 6371 # taken directly from mongodb
    RAD_PER_DEG = Math::PI/180

    EARTH_RADIUS = {
      :km => EARTH_RADIUS_KM,
      :m  => EARTH_RADIUS_KM*1000,
      :mi => EARTH_RADIUS_KM*0.621371192, # taken directly from mongodb
      :ft => EARTH_RADIUS_KM*5280*0.621371192,
      :sm => EARTH_RADIUS_KM*0.53995680345572 # sea mile
    }

    mattr_accessor :lng_symbols
    mattr_accessor :lat_symbols
    mattr_accessor :earth_radius
    mattr_accessor :geo_factory

    mattr_accessor :paginator
    mattr_accessor :default_per_page

    @@lng_symbols  = LNG_SYMBOLS.dup
    @@lat_symbols  = LAT_SYMBOLS.dup
    @@earth_radius = EARTH_RADIUS.dup
    @@paginator = :array
    @@default_per_page = 25

    included do
      attr_accessor :geo
      cattr_accessor :spatial_fields, :spatial_fields_indexed
      @@spatial_fields = []
      @@spatial_fields_indexed = []
    end

    module ClassMethods #:nodoc:

      # create spatial index for given field
      # @param [String,Symbol] name
      # @param [Hash] options options for spatial_index
      # http://www.mongodb.org/display/DOCS/Geospatial+Indexing#GeospatialIndexing-geoNearCommand
      def spatial_index name, options = {}
        self.spatial_fields_indexed << name
        index({name => '2d'}, options)
      end

    end

  end
end
