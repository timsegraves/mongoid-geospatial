require "spec_helper"

describe Mongoid::Geospatial::Point do

  it "should not inferfer with mongoid" do
    Bar.create!(name: "Moe's")
    Bar.count.should eql(1)
  end

  describe "(de)mongoize" do

    it "should mongoize array" do
      bar = Bar.new(location: [10, -9])
      bar.location.class.should eql(Mongoid::Geospatial::Point)
      bar.location.x.should be_within(0.1).of(10)
      bar.location.y.should be_within(0.1).of(-9)
    end

    it "should mongoize hash" do
      geom = Bar.new(location: {x: 10, y: -9}).location
      geom.class.should eql(Mongoid::Geospatial::Point)
      geom.x.should be_within(0.1).of(10)
      geom.y.should be_within(0.1).of(-9)
    end


    it "should accept an RGeo object" do
      point = RGeo::Geographic.spherical_factory.point 1, 2
      bar = Bar.create!(location: point)
      bar.location.x.should be_within(0.1).of(1)
      bar.location.y.should be_within(0.1).of(2)
    end

    describe "methods" do

      it "should have a .to_a" do
        bar = Bar.create!(location: [3,2])
        bar.location.to_a[0..1].should == [3.0, 2.0]
      end

      it "should have an array [] accessor" do
        bar = Bar.create!(location: [3,2])
        bar.location[0].should == 3.0
      end

      it "should have an ActiveModel symbol accessor" do
        bar = Bar.create!(location: [3,2])
        bar[:location].should == [3,2]
      end

      it "should calculate distance between points" do
        bar = Bar.create!(location: [5,5])
        bar2 = Bar.create!(location: [15,15])
        bar.location.distance(bar2.location).should be_within(1).of(1561283.8)
      end

  it "should calculate distance between points miles" do
    pending
    bar = Bar.create!(location: [5,5])
    bar2 = Bar.create!(location: [15,15])
    bar.location.distance(bar2.location).should be_within(1).of(1561283.8)
  end

  it "should calculate 3d distances by default" do
    bar = Bar.create! location: [-73.77694444, 40.63861111 ]
    bar2 = Bar.create! location: [-118.40, 33.94] #,:unit=>:mi, :spherical => true)
    bar.location.distance(bar2.location).to_i.should be_within(1).of(2469)
  end

    end

    # should raise
    # geom.to_geo

    describe "with rgeo" do
      before do
        require 'mongoid_geospatial_rgeo'
      end

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

      describe "instantiated" do

        let(:bar) { Bar.create!(name: 'Vitinho', location: [10,10]) }

        it "should demongoize to rgeo" do
          bar.location.class.should eql(Mongoid::Geospatial::Point)
        end

      end


    end

  end


end
