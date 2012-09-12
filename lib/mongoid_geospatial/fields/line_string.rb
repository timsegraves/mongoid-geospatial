module Mongoid
  module Geospatial
    class LineString < Array
      attr_accessor :geom

      def initialize(geom)
        @geom = geom
      end

      class << self

        # Database -> Object
        def demongoize(o)
          LineString.new(o)
        end

      end
    end
  end
end
