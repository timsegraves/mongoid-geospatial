module Mongoid
  module Spatial
    class Point

      include Mongoid::Fields::Serializable

      def deserialize(object)
        RGeo::Geographic.spherical_factory.point object["x"], object["y"]
      end

      def serialize(object)
        if object.respond_to? :x
          { "x" => object.x, "y" => object.y }
        else
          { "x" => object[0], "y" => object[1] }
        end
      end


    end
  end
end
