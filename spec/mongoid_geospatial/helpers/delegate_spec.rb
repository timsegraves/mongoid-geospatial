require "spec_helper"

describe Mongoid::Fields do

  context "delegate" do

    before do
      Bus.create_indexes
    end

    context 'x, y helpers' do

      let(:bus) { Bus.create!(name: "Far", location: [7,8]) }

      it "should set instance method x" do
        bus.x.should eq(7)
      end

      it "should set instance method y" do
        bus.y.should eq(8)
      end

      it "should set instance method x=" do
        bus.x = 9
        bus.x.should eq(9)
      end

      it "should set instance method y=" do
        bus.y = 9
        bus.y.should eq(9)
      end

    end

    it "should set instance methods x= and y=" do
      bus = Bus.create!(name: "B", location: [7,7])
      bus.x = 9; bus.y = 9
      bus.location.to_a.should eq([9,9])
    end

    it "should work fine with default values" do
      event = Event.create!(name: "Bvent")
      event.x = 9; event.y = 9
      event.location.to_a.should eq([9,9])
    end

    it "should not work fine with nils" do
      bus = Bus.create!(name: "B", location: nil)
      -> { bus.x = 9; bus.y = 9 }.should raise_error(NoMethodError)
    end

  end

end
