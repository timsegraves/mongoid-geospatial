require 'rgeo'
require 'mongoid/geospatial/ext/rgeo_spherical_point_impl'

module Mongoid
  module Geospatial
    # Wrapper to Rgeo's Point
    class Point
      def to_rgeo
        RGeo::Geographic.spherical_factory.point x, y
      end

      def rgeo_distance(other)
        to_rgeo.distance other.to_rgeo
      end
    end

    # Rgeo's GeometryField concept
    class GeometryField
      private

      def points
        map do |pair|
          RGeo::Geographic.spherical_factory.point(*pair)
        end
      end
    end

    # Wrapper to Rgeo's Line
    class Line < GeometryField
      def to_rgeo
        RGeo::Geographic.spherical_factory.line_string points
      end
    end

    # Wrapper to Rgeo's Polygon
    class Polygon < GeometryField
      def to_rgeo
        ring = RGeo::Geographic.spherical_factory.linear_ring points
        RGeo::Geographic.spherical_factory.polygon ring
      end
    end
  end
end
