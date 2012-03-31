require "spec_helper"

describe Mongoid::Geospatial do

  context "Class Stuff" do

    it "should have an lng_symbols accessor" do
      Mongoid::Geospatial.lng_symbols.should be_instance_of Array
      Mongoid::Geospatial.lng_symbols.should include :x
    end

    it "should have an lat_symbols accessor" do
      Mongoid::Geospatial.lat_symbols.should be_instance_of Array
      Mongoid::Geospatial.lat_symbols.should include :y
    end

  end


  context "Included" do
  end



end
