module GeoRuby
  module SimpleFeatures
    # GeoRuby Point
    class Point

      def mongoize
        [x, y]
      end

    end
  end
end
