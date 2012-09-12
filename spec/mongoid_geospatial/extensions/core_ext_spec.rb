require "spec_helper"

describe "Core Extensions" do

  describe Array do

    it "should have a #to_xy method" do
      [1,2,3].to_xy.should eql([1.0, 2.0])
    end

  end

  describe Hash do

    it "should have a #to_xy method" do
      { x: 1.1, y: 2.1 }.to_xy.should eql([1.1, 2.1])
    end

  end
end
