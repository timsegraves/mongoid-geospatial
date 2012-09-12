require "spec_helper"

describe Mongoid::Geospatial::LineString do

  describe "(de)mongoize" do

    it "should support a field mapped as linestring" do
      river = River.create!(source: [[5,5],[6,5],[6,6],[5,6]])
      river.source.should be_a Mongoid::Geospatial::LineString
    end

    describe "with rgeo" do
      # farm.area.should be_a RGeo::Geographic::SphericalPolygonImpl
    end

  end

end
