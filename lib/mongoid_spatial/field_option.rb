#require 'ostruct'

Mongoid::Fields.option :spatial do |model,field,options|
  options = {} unless options.kind_of?(Hash)
  lat_meth = options[:lat] || :lat
  lng_meth = options[:lng] || :lng
  model.class_eval do
    self.spatial_fields ||= []
    self.spatial_fields << field.name.to_sym if self.spatial_fields.kind_of? Array

    define_method "distance_from_#{field.name}" do |*args|
      self.distance_from(field.name, *args)
    end

  end
end
