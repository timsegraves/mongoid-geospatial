module Mongoid
  module Geospatial
    extend ActiveSupport::Concern


    GEO_FACTORY = RGeo::Geographic.spherical_factory

    included do
      attr_accessor :geo
      cattr_accessor :spatial_fields, :spatial_fields_indexed
      @@spatial_fields = []
      @@spatial_fields_indexed = []
    end

    module ClassMethods #:nodoc:
      # create spatial index for given field
      # @param [String,Symbol] name
      # @param [Hash] options options for spatial_index

      def spatial_index name, *options
        self.spatial_fields_indexed << name
        index [[ name, Mongo::GEO2D ]], *options
      end
    end

    # def distance(p2, opts = {})
    #   p1 = self.send(key)
      #   Mongoid::Geospatial.distance(p1, p2, opts)
      # end



    # def self.distance(p1,p2,opts = {})
    #   opts[:formula] ||= (opts[:spherical]) ? @@spherical_distance_formula : :pythagorean_theorem
    #   p1 = p1.to_lng_lat if p1.respond_to?(:to_lng_lat)
    #   p2 = p2.to_lng_lat if p2.respond_to?(:to_lng_lat)

    #   rads = Formulas.send(opts[:formula], p1, p2)

    #   if unit = earth_radius[opts[:unit]]
    #     opts[:unit] = (rads.instance_variable_get("@radian")) ? unit : unit * RAD_PER_DEG
    #   end

    #   rads *= opts[:unit].to_f if opts[:unit]
    #   rads

    # end

    mattr_accessor :geo_factory
    @@lng_symbols = GEO_FACTORY.dup


  end
end
