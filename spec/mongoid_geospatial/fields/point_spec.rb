require "spec_helper"

describe Mongoid::Geospatial::Point do

  describe "in use" do

    it "should mongoize array" do
      bar = Bar.new(location: [10, -9])
      bar.location.class.should eql(RGeo::Geographic::SphericalPointImpl)
      bar.location.x.should be_within(0.1).of(10)
      bar.location.y.should be_within(0.1).of(-9)
    end

    it "should mongoize hash" do
      bar = Bar.new(location: {x: 10, y: -9})
      bar.location.class.should eql(RGeo::Geographic::SphericalPointImpl)
      bar.location.x.should be_within(0.1).of(10)
      bar.location.y.should be_within(0.1).of(-9)
    end

    describe "instantiated" do

      let(:bar) { Bar.create!(name: 'Vitinho', location: [10,10]) }

      it "should demongoize to rgeo" do
        bar.location.class.should eql(RGeo::Geographic::SphericalPointImpl)
      end

    end

  end


end
