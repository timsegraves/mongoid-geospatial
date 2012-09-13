require 'rgeo'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'

module Mongoid
  module Geospatial

    class Point
      def to_geo
        RGeo::Geographic.spherical_factory.point x, y
      end
    end


    class Line < GeometryField
      def to_geo
        RGeo::Geographic.spherical_factory.line_string self
      end

    end

    class Polygon < GeometryField
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
