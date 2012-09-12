class Array
  def to_xy
    self[0..1].map(&:to_f)
  end
  alias :to_lng_lat :to_xy
end

class Hash
  def to_xy
    raise "Hash must have at least 2 items" if self.size < 2
    [to_x, to_y]
  end
  alias :to_lng_lat :to_xy

  def to_y
    v = (Mongoid::Geospatial.lat_symbols & self.keys).first
    return self[v].to_f if !v.nil? && self[v]
    raise "Hash must contain #{Mongoid::Geospatial.lat_symbols.inspect} if ruby version is less than 1.9" if RUBY_VERSION.to_f < 1.9
    raise "Hash cannot contain #{Mongoid::Geospatial.lng_symbols.inspect} as the second item if there is no #{Mongoid::Geospatial.lat_symbols.inspect}" if Mongoid::Geospatial.lng_symbols.index(self.keys[1])
    self.values[1].to_f
  end

  def to_x
    v = (Mongoid::Geospatial.lng_symbols & self.keys).first
    return self[v].to_f if !v.nil? && self[v]
    raise "Hash cannot contain #{Mongoid::Geospatial.lat_symbols.inspect} as the first item if there is no #{Mongoid::Geospatial.lng_symbols.inspect}" if Mongoid::Geospatial.lat_symbols.index(self.keys[0])
    self.values[0].to_f
  end
end
