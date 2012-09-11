class Farm
  include Mongoid::Document
  include Mongoid::Geospatial

  field :name,              type: String
  field :area,              type: Polygon,    spatial: true

  spatial_index :area
end
