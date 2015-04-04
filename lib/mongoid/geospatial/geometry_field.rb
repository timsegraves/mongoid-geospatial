module Mongoid
  module Geospatial
    #
    # Main Geometry Array
    #
    # All multi point classes inherit from this one:
    # LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon
    #
    class GeometryField < Array
      #
      # Determines the multi point geometry bounding box.
      # Useful to find map boundaries, and fit to screen.
      #
      def bounding_box
        max_x, min_x = -Float::MAX, Float::MAX
        max_y, min_y = -Float::MAX, Float::MAX
        each do |point|
          max_y = point[1] if point[1] > max_y
          min_y = point[1] if point[1] < min_y
          max_x = point[0] if point[0] > max_x
          min_x = point[0] if point[0] < min_x
        end
        [[min_x, min_y], [max_x, max_y]]
      end
      alias_method :bbox, :bounding_box

      #
      # Determines the center point of a multi point geometry.
      # Geometry may be closed or not.
      #
      def center_point
        min, max = *bbox
        [(min[0] + max[0]) / 2.0, (min[1] + max[1]) / 2.0]
      end
      alias_method :center, :center_point

      #
      # Generates a radius from the point
      #
      # @param [Numeric] r radius
      # @return [Array]  [point, r] point and radius in mongoid format
      def radius(r = 1)
        [center, r]
      end

      #
      # Generates a spherical radius from the point
      #
      # point.radius(x) ->  [point, x / earth radius]
      #
      # @see Point#radius
      # @return (Float)
      #
      def radius_sphere(r = 1, unit = :km)
        radius r.to_f / Mongoid::Geospatial.earth_radius[unit]
      end

      class << self
        #
        # Database -> Object
        #
        def demongoize(obj)
          obj && new(obj)
        end
      end
    end
  end
end
