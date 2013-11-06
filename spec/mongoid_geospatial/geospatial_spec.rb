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

  context "Creating indexes" do

    it "should create a 2d index" do
      Bar.create_indexes
      Bar.collection.indexes[:location => '2d'].should_not be_nil
    end

    it "should create a 2dsphere index" do
      Alarm.create_indexes
      Alarm.collection.indexes[:spot => '2dsphere'].should_not be_nil
    end

  end

  context "#nearby 2d" do

    before do
      Bar.create_indexes
    end

    let!(:jfk) do
      Bar.create(:name => 'jfk', :location => [-73.77694444, 40.63861111 ])
    end

    let!(:lax) do
      Bar.create(:name => 'lax', :location => [-118.40, 33.94])
    end

    it "should work with specifying specific center and different location attribute on collction" do
      Bar.nearby(lax.location).should == [lax, jfk]
    end

  end

  context "#nearby 2dsphere" do

    before do
      Alarm.create_indexes
    end

    let!(:jfk) do
      Alarm.create(:name => 'jfk', :spot => [-73.77694444, 40.63861111 ])
    end

    let!(:lax) do
      Alarm.create(:name => 'lax', :spot => [-118.40, 33.94])
    end

    it "should work with specifying specific center and different spot attribute on collction" do
      Alarm.nearby(lax.spot).should == [lax, jfk]
    end

  #   context ':maxDistance' do
  #     it "should get 1 item" do
  #       Bar.geo_near(lax.location, :spherical => true, :max_distance => 2465/Mongoid::Geospatial.earth_radius[:mi]).size.should == 1
  #     end

  #   end

  #     context ':distance_multiplier' do
  #       it "should multiply returned distance with multiplier" do
  #         Bar.geo_near(lax.location, :spherical => true, :distance_multiplier=> Mongoid::Geospatial.earth_radius[:mi]).second.geo[:distance].to_i.should be_within(1).of(2469)
  #       end
  #     end

  #     context ':unit' do
  #       it "should multiply returned distance with multiplier" do
  #         Bar.geo_near(lax.location, :spherical => true, :unit => :mi).second.geo[:distance].to_i.should be_within(1).of(2469)
  #       end

  #       it "should convert max_distance to radians with unit" do
  #         Bar.geo_near(lax.location, :spherical => true, :max_distance => 2465, :unit => :mi).size.should == 1
  #       end

  #     end

  #     context ':query' do
  #       it "should filter using extra query option" do
  #         # two record in the collection, only one's name is Munich
  #         Bar.geo_near(jfk.location, :query => {:name => jfk.name}).should == [jfk]
  #       end
  #     end

  #   end

  #   context 'criteria chaining' do
  #     it "should filter by where" do
  #       Bar.where(:name => jfk.name).geo_near(jfk.location).should == [jfk]
  #       Bar.any_of({:name => jfk.name},{:name => lax.name}).geo_near(jfk.location).should == [jfk,lax]
  #     end

  #     it 'should skip 1' do
  #       Bar.skip(1).geo_near(jfk.location).size.should == 1
  #     end

  #     it 'should limit 1' do
  #       Bar.limit(1).geo_near(jfk.location).size.should == 1
  #     end
  #   end
  # end

  # context ':paginate' do
  #   before do
  #     Bar.create_indexes
  #     50.times do
  #       Bar.create({:location => [rand(360)-180,rand(360)-180]})
  #     end
  #   end

  #   [nil,1,2].each do |page|
  #     it "page=#{page} should have 25" do
  #       Bar.geo_near([1,1], :page => page).size.should == 25
  #     end
  #   end

  #   it "page=3 should have 0" do
  #     Bar.geo_near([1,1], :page => 20).size.should == 0
  #   end

  #   it "per_page=5" do
  #     Bar.geo_near([1,1], :page => 1, :per_page => 5).size.should == 5
  #   end
  end

end
