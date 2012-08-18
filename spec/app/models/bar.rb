class Bar
  include Mongoid::Document
  include Mongoid::Geospatial

  field :name, type: String
  field :location, type: Array
  field :lat_lng, type: Point

  has_one :rating, as: :ratable
  index location: "2d"
end
