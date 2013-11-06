module RGeo
  module Geographic
    # RGeo Point
    class SphericalPointImpl

      def to_a
        [x, y, z]
      end

      def [](index)
        to_a[index]
      end

    end
  end
end
