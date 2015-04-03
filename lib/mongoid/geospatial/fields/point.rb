module Mongoid
  module Geospatial
    # Point
    #
    class Point
      include Enumerable
      attr_reader :x, :y

      def initialize(x, y, z=nil)
         @x, @y, @z = x, y, z
      end

      # Object -> Database
      # Let's store NilClass if we are invalid.
      #
      # @return (Array)
      def mongoize
        return nil unless x && y
        [x, y]
      end
      alias_method :to_a,  :mongoize
      alias_method :to_xy, :mongoize

      def [](args)
        mongoize[args]
      end

      def each
        yield x
        yield y
      end
      #
      # Point representation as a Hash
      #
      # @return (Hash)
      def to_hsh(xl = :x, yl = :y)
        { xl => x, yl => y }
      end
      alias_method :to_hash, :to_hsh


      def radius(r = 1)
        [mongoize, r]
      end

      def radius_sphere(r = 1, unit = :km)
        radius r.to_f / Mongoid::Geospatial.earth_radius[unit]
      end

      #
      # Am I valid?
      #
      # Validates that x & y are `Numeric`
      #
      def valid?
        x && y && x.is_a?(Numeric) && y.is_a?(Numeric)
      end

      #
      # Point definition as string
      #
      # "x, y"
      #
      # @return [String] Point as comma separated String
      def to_s
        "#{x}, #{y}"
      end

      #
      # Distance calculation methods. Thinking about not using it
      # One needs to choose and external lib. GeoRuby or RGeo
      #
      # Return the distance between the 2D points (ie taking care
      # only of the x and y coordinates), assuming the points are
      # in projected coordinates. Euclidian distance in whatever
      # unit the x and y ordinates are.
      # def euclidian_distance(point)
      #   Math.sqrt((point.x - x)**2 + (point.y - y)**2)
      # end

      # # Spherical distance in meters, using 'Haversine' formula.
      # # with a radius of 6471000m
      # # Assumes x is the lon and y the lat, in degrees (Changed
      # in version 1.1).
      # # The user has to make sure using this distance makes sense
      # (ie she should be in latlon coordinates)
      # def spherical_distance(point,r=6370997.0)
      #   dlat = (point.lat - lat) * DEG2RAD / 2
      #   dlon = (point.lon - lon) * DEG2RAD / 2

      #   a = Math.sin(dlat)**2 + Math.cos(lat * DEG2RAD) *
      #         Math.cos(point.lat * DEG2RAD) * Math.sin(dlon)**2
      #   c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      #   r * c
      # end

      class << self
        #
        # Sanitize a `Point` from a `String`
        #
        # Makes life easier:
        # ""         ->    []
        # "1, 2"     ->    [1.0, 2.0]
        # "1.1 2.2"  ->    [1.1, 2.2]
        #
        # @return (Array)
        #
        def from_string(str)
          return nil if str.empty?
          str.split(/,|\s/).reject(&:empty?).map(&:to_f)
        end

        #
        # Sanitize a `Point` from an `Array`
        #
        # Also makes life easier:
        # []          ->   []
        # [1,2]       ->   [1.0, 2.0]
        #
        # @return (Array)
        #
        def from_array(ary)
          return nil if ary.empty?
          ary.flatten[0..1].map(&:to_f)
        end

        # Throw error on wrong hash, just for a change.
        def from_hash(hsh)
          fail 'Hash must have at least 2 items' if hsh.size < 2
          [from_hash_x(hsh), from_hash_y(hsh)]
        end

        def demongoize(object)
          Point.new(*object) if object
        end
        #
        # Object -> Database
        #
        def mongoize(object)
          case object
          when Point  then object.mongoize
          when String then from_string(object)
          when Array  then from_array(object)
          when Hash   then from_hash(object)
          when NilClass then nil
          else
            return object.to_xy if object.respond_to?(:to_xy)
            fail 'Invalid Point'
          end
        end

        # Converts the object that was supplied to a criteria
        # into a database friendly form.
        def evolve(object)
          object.respond_to?(:x) ? object.mongoize : object
        end

        private

        def from_hash_y(hsh)
          v = (Mongoid::Geospatial.lat_symbols & hsh.keys).first
          return hsh[v].to_f if !v.nil? && hsh[v]
          fail "Hash must contain #{Mongoid::Geospatial.lat_symbols.inspect} if Ruby version is less than 1.9" if RUBY_VERSION.to_f < 1.9
          fail "Hash cannot contain #{Mongoid::Geospatial.lng_symbols.inspect} as the second item if there is no #{Mongoid::Geospatial.lat_symbols.inspect}" if Mongoid::Geospatial.lng_symbols.index(hsh.keys[1])
          hsh.values[1].to_f
        end

        def from_hash_x(hsh)
          v = (Mongoid::Geospatial.lng_symbols & hsh.keys).first
          return hsh[v].to_f if !v.nil? && hsh[v]
          fail "Hash cannot contain #{Mongoid::Geospatial.lat_symbols.inspect} as the first item if there is no #{Mongoid::Geospatial.lng_symbols.inspect}" if Mongoid::Geospatial.lat_symbols.index(hsh.keys[0])
          hsh.values[0].to_f
        end
      end # << self
    end # Point
  end # Geospatial
end # Mongoid
