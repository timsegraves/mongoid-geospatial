require 'georuby'
# require 'mongoid_geospatial/extensions/georuby'

module Mongoid
  module Geospatial

    class Point
      def to_geo
        GeoRuby::SimpleFeatures::Point.from_x_y(x, y)
      end
    end


    class Line < Array
      def to_geo
        GeoRuby::SimpleFeatures::LineString.from_array(self)
      end

    end

    class Polygon < GeometryField
      def to_geo
        GeoRuby::SimpleFeatures::Polygon.from_array(self)
      end

    end
  end
end
