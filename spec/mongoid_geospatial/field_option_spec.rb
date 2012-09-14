require "spec_helper"

describe Mongoid::Fields do

  context "spatial" do
    before do
      Bar.create_indexes
    end

    it "should set some class methods" do
      far  = Bar.create!(name: "Far", location: [7,7])
      near = Bar.create!(name: "Near", location: [2,2])
      Bar.nearby([1,1]).should eq([near, far])
    end

  end

  context "geom" do
  end

end
