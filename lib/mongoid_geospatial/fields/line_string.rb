module Mongoid
  module Geospatial
    class LineString < GeometryField

      class << self

        # Database -> Object
        def demongoize(o)
          LineString.new(o)
        end

      end
    end
  end
end
