require "spec_helper"

describe Mongoid::Fields do

  context "spatial" do

    before do
      Alarm.create_indexes
    end

    it "should created indexes" do
      pending 'check indexes on mongoid 4'
      Alarm.index_options.keys.should include({:spot => '2dsphere'})
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
