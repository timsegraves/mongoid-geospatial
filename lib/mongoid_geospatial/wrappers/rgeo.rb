require 'rgeo'
require 'mongoid_geospatial/ext/rgeo_spherical_point_impl'

module Mongoid
  module Geospatial

    class Point
      def to_rgeo
        RGeo::Geographic.spherical_factory.point x, y
      end

      def rgeo_distance other
        to_rgeo.distance other.to_rgeo
      end

    end

    class GeometryField
      private
      def points
        self.map do |pair|
          RGeo::Geographic.spherical_factory.point(*pair)
        end
      end
    end

    class Line < GeometryField
      def to_rgeo
        RGeo::Geographic.spherical_factory.line_string points
      end

    end

    class Polygon < GeometryField
      def to_rgeo
        ring = RGeo::Geographic.spherical_factory.linear_ring points
        RGeo::Geographic.spherical_factory.polygon ring
      end
    end

  end

end
