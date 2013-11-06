require 'geo_ruby'
# require 'mongoid_geospatial/extensions/georuby'

module Mongoid
  module Geospatial

    class Point
      delegate :distance, :to => :to_geo

      def to_geo
        GeoRuby::SimpleFeatures::Point.xy(x, y)
      end

      def distance other
        to_geo.spherical_distance(other.to_geo)
      end

      def self.mongoize(obj)
        case obj
        when GeoRuby::SimpleFeatures::Point then [obj.x, obj.y]
        when Point then obj.mongoize
        when Array then Geospatial.from_array(obj)
        when Hash  then Geospatial.from_hash(obj)
        else obj
        end
      end
    end


    class Line < GeometryField

      def to_geo
        GeoRuby::SimpleFeatures::LineString.from_coordinates([self])
      end

    end

    class Polygon < GeometryField

      def to_geo
        GeoRuby::SimpleFeatures::Polygon.from_coordinates([self])
      end

    end
  end
end
