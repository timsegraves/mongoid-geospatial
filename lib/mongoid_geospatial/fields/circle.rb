module Mongoid
  module Geospatial
    class Circle < GeometryField
      attr_accessor :center, :radius

      def point
        Point.new(self[0])
      end
      alias :point :center

      def radius
        self[1]
      end

    end
  end
end
