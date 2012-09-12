require 'mongoid_geospatial'
module Mongoid
  module Geospatial

    class Point
      def to_geo
        RGeo::Geographic.spherical_factory.point x, y
      end
    end


    class LineString < Array
      def to_geo
        RGeo::Geographic.spherical_factory.line_string self
      end

    end

    class Polygon < Array
      def to_geo
        points = self.map do |pair|
          RGeo::Geographic.spherical_factory.point *pair
        end
        ring = RGeo::Geographic.spherical_factory.linear_ring points
        RGeo::Geographic.spherical_factory.polygon ring
      end

    end
  end
end
