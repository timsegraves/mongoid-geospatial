require 'spec_helper'

describe Mongoid::Geospatial::Point do

  it 'should not interfer with mongoid' do
    Bar.create!(name: "Moe's")
    expect(Bar.count).to eql(1)
  end

  it 'should not fail if point is nil' do
    bar = Bar.create!(name: "Moe's")
    expect(bar.location).to be_nil
  end

  it 'should set point methodically' do
    bar = Bar.create!(name: "Moe's", location: Mongoid::Geospatial::Point.new)
    bar.location = Mongoid::Geospatial::Point.new(8, 8)
    expect(bar.save).to be_truthy
    expect(Bar.first.location.x).to eq(8)
  end

  it 'should set point with comma separated text' do
    bar = Bar.create!(name: "Moe's", location: Mongoid::Geospatial::Point.new)
    bar.location = '2.99,3.99'
    expect(bar.location.mongoize).to eq([2.99, 3.99])
  end

  it 'should set point with space separated text' do
    bar = Bar.create!(name: "Moe's", location: Mongoid::Geospatial::Point.new)
    bar.location = '2.99 3.99'
    expect(bar.location.mongoize).to eq([2.99, 3.99])
  end

  it 'should set point with space comma separated text' do
    bar = Bar.create!(name: "Moe's", location: Mongoid::Geospatial::Point.new)
    bar.location = '2.99 ,  3.99'
    expect(bar.location.mongoize).to eq([2.99, 3.99])
  end

  it 'should set point to nil' do
    bar = Bar.create!(name: "Moe's", location: [1, 1])
    bar.location = nil
    expect(bar.location).to be_nil
    expect(bar.save).to be_truthy
    expect(Bar.where(location: nil).first).to eq(bar)
  end

  it 'should set point empty string to nil' do
    bar = Bar.create!(name: "Moe's", location: [1, 1])
    bar.location = ''
    expect(bar.location).to be_nil
    expect(bar.save).to be_truthy
    expect(Bar.where(location: nil).first).to eq(bar)
  end

  it 'should set point empty array to nil' do
    bar = Bar.create!(name: "Moe's", location: [1, 1])
    bar.location = []
    expect(bar.location).to be_nil
    expect(bar.save).to be_truthy
    expect(Bar.where(location: nil).first).to eq(bar)
  end

  describe 'methods' do

    let(:bar) { Bar.create!(location: [3, 2]) }

    it 'should have a .to_a' do
      expect(bar.location.to_a[0..1]).to eq([3.0, 2.0])
    end

    it 'should have an array [] accessor' do
      expect(bar.location[0]).to eq(3.0)
    end

    it 'should have an ActiveModel symbol accessor' do
      expect(bar[:location]).to eq([3, 2])
    end

    it 'should have a radius helper' do
      expect(bar.location.radius).to eql([[3.0, 2.0], 1])
    end

    it 'should have a radius sphere helper' do
      expect(bar.location.radius_sphere[1]).to be_within(0.0001).of(0.00015)
    end

    it 'should have a radius sphere helper in meters' do
      expect(bar.location.radius_sphere(1000, :m)[1]).to be_within(0.0001).of(0.00015)
    end

    it 'should have a radius sphere helper in miles' do
      expect(bar.location.radius_sphere(1, :mi)[1]).to be_within(0.0001).of(0.00025)
    end

  end

  describe 'queryable' do

    before do
      Bar.create_indexes
    end

    describe ':near :near_sphere' do

      let!(:berlin) do
        Bar.create(name: :berlin, location: [52.30, 13.25])
      end

      let!(:prague) do
        Bar.create(name: :prague, location: [50.5, 14.26])
      end

      let!(:paris) do
        Bar.create(name: :paris, location: [48.48, 2.20])
      end

      let!(:jim) do
        Person.new(location: [41.23, 2.9])
      end

      it 'returns the documents sorted closest to furthest' do
        expect(Bar.where(:location.near => jim.location))
          .to eq([paris, prague, berlin])
      end

      it 'returns the documents sorted closest to furthest' do
        expect(Bar.near(location: jim.location))
          .to eq([paris, prague, berlin])
      end

      it 'returns the documents sorted closest to furthest sphere' do
        person = Person.new(location: [41.23, 2.9])
        expect(Bar.near_sphere(location: jim.location))
          .to eq([paris, prague, berlin])
      end

      it 'returns the documents sorted closest to furthest sphere' do
        person = Person.new(location: [41.23, 2.9])
        expect(Bar.where(:location.near_sphere => jim.location))
          .to eq([paris, prague, berlin])
      end

      it 'returns the documents sorted closest to furthest with max' do
        expect(Bar.near(location: jim.location).max_distance(location: 10).to_a)
          .to eq([paris]) # , prague, berlin ]
      end

    end

    describe ':within_circle :within_spherical_circle' do
      let!(:mile1) do
        Bar.create(name: 'mile1', location: [-73.997345, 40.759382])
      end

      let!(:mile3) do
        Bar.create(name: 'mile3', location: [-73.927088, 40.752151])
      end

      let!(:mile7) do
        Bar.create(name: 'mile7', location: [-74.0954913, 40.7161472])
      end

      let!(:mile9) do
        Bar.create(name: 'mile9', location: [-74.0604951, 40.9178011])
      end

      let!(:elvis) do
        Person.new(location: [-73.98, 40.75])
      end

      it 'returns the documents within a circle' do
        pending "Moped"
        expect(Bar.where(:location.within_circle =>
                         [elvis.location, 250.0 /
                           Mongoid::Geospatial::EARTH_RADIUS_KM]).to_a)
          .to eq([mile1])
      end

      it 'returns the documents within a circle' do
        pending "Moped"
        expect(Bar.where(:location.within_circle => [elvis.location,
                           500.0 / Mongoid::Geospatial::EARTH_RADIUS_KM])
                 .to_a).to include(mile3)
      end

      it 'returns the documents within a spherical circle' do
        pending "Moped"
        expect(Bar.where(:location.within_spherical_circle =>
                         [elvis.location, 0.0005]).to_a).to eq([mile1])
      end

      it 'returns the documents within a spherical circle 2' do
        pending "Moped"
        expect(Bar.where(:location.within_spherical_circle =>
                         [elvis.location, 0.5]).to_a).to include(mile9)
      end

      it 'returns the documents within a center circle' do
        pending "Moped"
        expect(Bar.where(:location.within_center_circle =>
                         [elvis.location, 0.0005]).to_a).to eq([mile1])
      end


      it 'returns the documents within a box' do
        pending "Moped"
        expect(Bar.within_box(location: [elvis.location,
                                elvis.location.map(&:ceil)]).to_a)
          .to eq([mile3])
      end

    end

  end

  describe '(de)mongoize' do

    it 'should mongoize array' do
      bar = Bar.new(location: [10, -9])
      expect(bar.location.class).to eql(Mongoid::Geospatial::Point)
      expect(bar.location.x).to be_within(0.1).of(10)
      expect(bar.location.y).to be_within(0.1).of(-9)
    end

    it 'should mongoize hash' do
      geom = Bar.new(location: { x: 10, y: -9 }).location
      expect(geom.class).to eql(Mongoid::Geospatial::Point)
      expect(geom.x).to be_within(0.1).of(10)
      expect(geom.y).to be_within(0.1).of(-9)
    end

    it 'should mongoize hash with symbols in any order' do
      geom = Bar.new(location: { y: -9, x: 10 }).location
      expect(geom.class).to eql(Mongoid::Geospatial::Point)
      expect(geom.x).to be_within(0.1).of(10)
      expect(geom.y).to be_within(0.1).of(-9)
    end

    it 'should mongoize hash with string keys in any order' do
      geom = Bar.new(location: { 'y' => -9, 'x' => 10 }).location
      expect(geom.class).to eql(Mongoid::Geospatial::Point)
      expect(geom.x).to be_within(0.1).of(10)
      expect(geom.y).to be_within(0.1).of(-9)
    end

    # should raise
    # geom.to_geo

    describe 'with rgeo' do

      describe 'instantiated' do

        let(:bar) { Bar.create!(name: 'Vitinho', location: [10, 10]) }

        it 'should demongoize to rgeo' do
          expect(bar.location.class).to eql(Mongoid::Geospatial::Point)
        end

      end

    end

  end

end
