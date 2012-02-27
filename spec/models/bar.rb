class Bar
  include Mongoid::Document
  include Mongoid::Spatial

  field :name, :type => String
  field :location, :type => Point, :spatial => true
  references_one :rating, :as => :ratable
  spatial_index :location
end
