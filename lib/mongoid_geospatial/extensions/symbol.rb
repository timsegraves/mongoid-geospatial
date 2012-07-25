# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Symbol #:nodoc:

      # return a class that will accept a value to convert the query correctly for near
      #
      # @param [Symbol] calc This accepts :sphere
      #
      # @return [Criterion::NearSpatial]

      def near(calc = :flat)
        Criterion::NearSpatial.new(:operator => get_op('near',calc), :key => self)
      end

      # alias for self.near(:sphere)
      #
      # @return [Criterion::NearSpatial]
      def near_sphere
        self.near(:sphere)
      end

      # @param [Symbol] shape :box,:polygon,:center,:center_sphere
      #
      # @return [Criterion::WithinSpatial]
      def within(shape)
        shape = get_op(:center,:sphere) if shape == :center_sphere
        Criterion::WithinSpatial.new(:operator => shape.to_s , :key => self)
      end

      private

      def get_op operator, calc
        if calc.to_sym == :sphere
          "#{operator}Sphere"
        else
          operator.to_s
        end
      end

    end
  end
end


::Symbol.__send__(:include, Mongoid::Extensions::Symbol)
