require "spec_helper"

describe Mongoid::Criterion::WithinSpatial do

  let(:within) do
    {
      :box     => Mongoid::Criterion::WithinSpatial.new(:key => :field, :operator => "box"),
      :center  => Mongoid::Criterion::WithinSpatial.new(:key => :field, :operator => "center"),
      :polygon => Mongoid::Criterion::WithinSpatial.new(:key => :field, :operator => "polygon"),
      :center_sphere => Mongoid::Criterion::WithinSpatial.new(:key => :field, :operator => "box"),
    }
  end

  context "#to_mongo_query" do

    {
      :box =>
      {
        'Array of Arrays' => [[10,20], [15,25]],
        'Array of Hashes' => [{ x: 10, y: 20 }, { x: 15, y: 25 }],
        'Hash of Hashes'  => { a: { x: 10, y: 20 }, b: { x: 15, y: 25 }}
      },
      :polygon =>
      {
        'Array of Arrays' => [[10,20], [15,25]],
        'Array of Hashes' => [{ x: 10, y: 20 }, { x: 15, y: 25 }],
        'Hash of Hashes'  => { a: { x: 10, y: 20 }, b: { x: 15, y: 25 }}
      },
      :center =>
      {
        'Point'           => [[1,2],5],
        'Hash Point'      => {:point => [-73.98, 40.77], :max => 5},
        'Hash Point Unit' => {:point => [-73.98, 40.77], :max => 5, :unit => :km}
      },
      :center_sphere =>
      {
        'Point'           => [[1,2],5],
        'Hash Point'      => {:point => [-73.98, 40.77], :max => 5},
        'Hash Point Unit' => {:point => [-73.98, 40.77], :max => 5, :unit => :km}
      }
    }.each do |shape, points|

      points.each do |input_name,input|

        it "should generate a #{shape} query with '#{input_name}'" do
          within[shape].to_mongo_query(input).should be_a_kind_of(Hash)
        end

      end
    end

  end # context
end # describe

