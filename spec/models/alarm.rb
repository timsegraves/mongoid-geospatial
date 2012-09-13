class Alarm
  include Mongoid::Document
  include Mongoid::Geospatial

  field :radius,  type: Circle
  field :area,    type: Box


end
