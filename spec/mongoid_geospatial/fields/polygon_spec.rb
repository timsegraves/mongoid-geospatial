require "spec_helper"

describe Mongoid::Geospatial::Polygon do

  describe "(de)mongoize" do

    it "should support a field mapped as polygon" do
      farm = Farm.create!(area: [[5,5],[6,5],[6,6],[5,6]])
      farm.area.should be_a Mongoid::Geospatial::Polygon
    end

    describe "with rgeo" do
      # farm.area.should be_a RGeo::Geographic::SphericalPolygonImpl
    end

  end

end
