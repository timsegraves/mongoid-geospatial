require "spec_helper"

describe Mongoid::Geospatial::Box do

  it "should work" do
    alarm = Alarm.new(area: [[1,2], [3,4]])
    alarm.area.should be_a Mongoid::Geospatial::Box
  end


end
