module Mongoid
  module Geospatial
    class LineString

      def mongoize
        to_a
      end

      class << self
        def demongoize(object)
          RGeo::Geographic.spherical_factory.line_string object
        end

      end
    end
  end
end
