require "spec_helper"

describe Mongoid::Geospatial::Point do

  before(:all) do
    Mongoid::Geospatial.send(:remove_const, 'Point')
    load "#{File.dirname(__FILE__)}/../../../lib/mongoid_geospatial/fields/point.rb"
    Object.send(:remove_const, 'Bar')
    load "#{File.dirname(__FILE__)}/../../models/bar.rb"
  end

  it "should not inferfer with mongoid" do
    Bar.create!(name: "Moe's")
    Bar.count.should eql(1)
  end

  it "should not respond to distance before loading external" do
    bar = Bar.create!(location: [5,5])
    bar.location.should_not respond_to(:distance)
  end


  describe "queryable" do

    before do
      Mongoid::Geospatial.use_rgeo
      Bar.create_indexes
    end

    describe "(de)mongoize" do

      it "should mongoize array" do
        geom = Bar.new(location: [10, -9]).location
        geom.class.should eql(Mongoid::Geospatial::Point)
        geom.to_geo.class.should eql(RGeo::Geographic::SphericalPointImpl)
        geom.x.should be_within(0.1).of(10)
        geom.to_geo.y.should be_within(0.1).of(-9)
      end

      it "should mongoize hash" do
        geom = Bar.new(location: {x: 10, y: -9}).location
        geom.class.should eql(Mongoid::Geospatial::Point)
        geom.to_geo.class.should eql(RGeo::Geographic::SphericalPointImpl)
      end

      it "should accept an RGeo object" do
        point = RGeo::Geographic.spherical_factory.point 1, 2
        bar = Bar.create!(location: point)
        bar.location.x.should be_within(0.1).of(1)
        bar.location.y.should be_within(0.1).of(2)
      end

      it "should calculate 3d distances by default" do
        bar = Bar.create! location: [-73.77694444, 40.63861111 ]
        bar2 = Bar.create! location: [-118.40, 33.94] #,:unit=>:mi, :spherical => true)
        bar.location.distance(bar2.location).to_i.should be_within(1).of(3978262)
      end

    end
  end
end
