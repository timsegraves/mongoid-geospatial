Mongoid::Fields.option :spatial do |model,field,options|
  options = {} unless options.kind_of?(Hash)
  # x_meth = options[:x] || :x
  # y_meth = options[:y] || :y

  # model.instance_eval do # wont work
  # #   define_method "near_#{field.name}" do |*args|
  # #     self.where(field.name => args)
  # #   end
  # end

  model.class_eval do
    (self.spatial_fields ||= []) << field.name.to_sym
  #   define_method "distance_from_#{field.name}" do |*args|
  #     self.distance_from(field.name, *args)
  #   end
  end

end
