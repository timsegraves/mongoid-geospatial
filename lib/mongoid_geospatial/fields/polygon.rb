module Mongoid
  module Geospatial
    class Polygon < Array
      attr_accessor :geom

      def initialize(geom)
        @geom = geom
      end

      class << self

        # Database -> Object
        def demongoize(o)
          Polygon.new(o)
        end

      end

    end
  end
end
