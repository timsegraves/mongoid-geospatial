module Mongoid
  module Geospatial
    class Polygon

      if Mongoid::VERSION > '2.2' && Mongoid::VERSION < '3'
        define_method :instantiate do |name, options|
          super
        end
      end

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
