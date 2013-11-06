require "spec_helper"

describe Mongoid::Fields do

  context "spatial" do

    before do
      Alarm.create_indexes
    end

    it "should created indexes" do
      Alarm.collection.indexes[:spot => '2dsphere'].should_not be_nil
    end

    it "should set spatial fields" do
      Alarm.spatial_fields.should eql([:spot])
    end

    it "should work fine indexed" do
      far  = Alarm.create!(name: "Far", spot: [7,7])
      far.spot.should be_instance_of(Mongoid::Geospatial::Point)
    end

  end

end
