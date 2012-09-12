module Mongoid
  module Geospatial
    class Point
      attr_accessor :x, :y

      def initialize(x, y)
        @x, @y = x, y
      end

      # Object -> Database
      def mongoize
        [x, y]
      end

      def [](args)
        mongoize[args]
      end

      class << self

        # Database -> Object
        def demongoize(object)
          # return unless object && !object.empty?
          Point.new(object[0], object[1])
        end

        def mongoize(object)
          case object
          when Point then object.mongoize
          when Hash then [object[:x], object[:y]]
          else object
          end
        end

        # Converts the object that was supplied to a criteria
        # into a database friendly form.
        def evolve(object)
          object.respond_to?(:x) ? object.mongoize : object
        end
      end

    end
  end
end
