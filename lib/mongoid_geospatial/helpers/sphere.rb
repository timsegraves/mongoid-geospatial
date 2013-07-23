#
# Mongoid fields extension
#
# field :foo, :sphere => true
#
Mongoid::Fields.option :sphere do |model, field, options|
  # options = {} unless options.kind_of?(Hash)

  model.class_eval do

    self.spatial_fields << field.name.to_sym
    self.spatial_fields_indexed << field.name.to_sym

    # Create 2Dsphere index
    sphere_index field.name

  end
end
