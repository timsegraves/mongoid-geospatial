require 'rgeo'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'

module Mongoid
  module Geospatial

    class Point
      delegate :distance, :to => :to_geo

      def to_geo
        RGeo::Geographic.spherical_factory.point x, y
      end

      def self.mongoize(obj)
        case obj
        when RGeo::Geographic::SphericalPointImpl then [obj.x, obj.y]
        when Point then obj.mongoize
        when Array then obj.to_xy
        when Hash  then obj.to_xy
        else obj
        end
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
