class Farm
  include Mongoid::Document
  include Mongoid::Geospatial

  field :name, :type => String
  #field :location, :type => Point #, :spatial => true
  field :area, :type => Polygon

  #spatial_index :location
end
