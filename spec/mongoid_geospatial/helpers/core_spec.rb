module Mongoid
  module Geospatial
    def self.from_array(ary)
      ary[0..1].map(&:to_f)
    end

    def self.from_hash(hsh)
      fail 'Hash must have at least 2 items' if hsh.size < 2
      [from_hash_x(hsh), from_hash_y(hsh)]
    end

    def self.from_hash_y(hsh)
      v = (Mongoid::Geospatial.lat_symbols & hsh.keys).first
      return hsh[v].to_f if !v.nil? && hsh[v]
      fail "Hash must contain #{Mongoid::Geospatial.lat_symbols.inspect} if ruby version is less than 1.9" if RUBY_VERSION.to_f < 1.9
      fail "Hash cannot contain #{Mongoid::Geospatial.lng_symbols.inspect} as the second item if there is no #{Mongoid::Geospatial.lat_symbols.inspect}" if Mongoid::Geospatial.lng_symbols.index(hsh.keys[1])
      hsh.values[1].to_f
    end

    def self.from_hash_x(hsh)
      v = (Mongoid::Geospatial.lng_symbols & hsh.keys).first
      return hsh[v].to_f if !v.nil? && hsh[v]
      fail "Hash cannot contain #{Mongoid::Geospatial.lat_symbols.inspect} as the first item if there is no #{Mongoid::Geospatial.lng_symbols.inspect}" if Mongoid::Geospatial.lat_symbols.index(keys[0])
      values[0].to_f
    end
  end
end
