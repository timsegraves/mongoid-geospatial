require 'spec_helper'

describe Mongoid::Fields do
  context 'delegate' do
    before do
      Bus.create_indexes
    end

    context 'x, y helpers' do
      let(:bus) { Bus.create!(name: 'Far', location: [7, 8]) }

      it 'should set instance method x' do
        expect(bus.x).to eq(7)
      end

      it 'should set instance method y' do
        expect(bus.y).to eq(8)
      end

      it 'should set instance method x=' do
        bus.x = 9
        expect(bus.x).to eq(9)
      end

      it 'should set instance method y=' do
        bus.y = 9
        expect(bus.y).to eq(9)
      end
    end

    it 'should set instance methods x= and y=' do
      bus = Bus.create!(name: 'B', location: [7, 7])
      bus.x = 9; bus.y = 9
      expect(bus.location.to_a).to eq([9, 9])
    end

    it 'should work fine with default values' do
      event = Event.create!(name: 'Bvent')
      event.x = 9; event.y = 9
      expect(event.location.to_a).to eq([9, 9])
    end

    it 'should not work fine with nils' do
      bus = Bus.create!(name: 'B', location: nil)
      expect { bus.x = 9; bus.y = 9 }.to raise_error(NoMethodError)
    end
  end
end
