module Mongoid
  module Spatial
    class LineString

      include Mongoid::Fields::Serializable

      def deserialize(object)
        RGeo::Geographic.spherical_factory.line_string *object
      end

      def serialize(object)
        object.to_a
      end


    end
  end
end
