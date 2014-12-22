#
# Mongoid fields extension
#
# field :foo, :delegate => {opts
#
Mongoid::Fields.option :delegate do |model, field, options|
  options = {} unless options.is_a?(Hash)
  x_meth = options[:x] || :x
  y_meth = options[:y] || :y

  model.instance_eval do
    define_method x_meth do
      self[field.name][0]
    end

    define_method y_meth do
      self[field.name][1]
    end

    define_method "#{x_meth}=" do |arg|
      self[field.name][0] = arg
    end

    define_method "#{y_meth}=" do |arg|
      self[field.name][1] = arg
    end
  end
end
