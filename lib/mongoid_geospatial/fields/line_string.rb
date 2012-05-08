module Mongoid
  module Geospatial
    class LineString

      def mongoize(object)
        RGeo::Geographic.spherical_factory.line_string *object
      end

      def demongoize(object)
        object.to_a
      end


    end
  end
end
