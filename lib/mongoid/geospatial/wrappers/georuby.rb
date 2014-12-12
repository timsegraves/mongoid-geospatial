require 'geo_ruby'

module Mongoid
  module Geospatial
    # Wrapper to GeoRuby's Point
    class Point
      delegate :distance, to: :to_geo

      def to_geo
        return unless valid?
        GeoRuby::SimpleFeatures::Point.xy(x, y)
      end

      def geo_distance(other)
        to_geo.spherical_distance(other.to_geo)
      end
    end

    # Wrapper to GeoRuby's Line
    class Line < GeometryField
      def to_geo
        GeoRuby::SimpleFeatures::LineString.from_coordinates(self)
      end
    end

    # Wrapper to GeoRuby's Polygon
    class Polygon < GeometryField
      def to_geo
        GeoRuby::SimpleFeatures::Polygon.from_coordinates(self)
      end
    end
  end
end
