require "spec_helper"

describe Mongoid::Fields do

  context "spatial" do

    it "should set some class methods" do
      Bar.near_location([1,1]).should eq([])
    end

  end

  context "geom" do
  end

end
