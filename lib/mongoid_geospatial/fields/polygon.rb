module Mongoid
  module Geospatial
    class Polygon < GeometryField

      class << self

        # Database -> Object
        def demongoize(o)
          Polygon.new(o)
        end

      end

    end
  end
end
