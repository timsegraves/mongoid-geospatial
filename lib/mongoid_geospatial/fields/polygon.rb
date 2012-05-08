module Mongoid
  module Geospatial
    class Polygon

      def mongoize(object)
        points = object.map do |pair|
          RGeo::Geographic.spherical_factory.point *pair
        end
        ring = RGeo::Geographic.spherical_factory.linear_ring points
        RGeo::Geographic.spherical_factory.polygon ring
      end

      def demongoize(object)
        object #.flatten
      end


    end
  end
end
