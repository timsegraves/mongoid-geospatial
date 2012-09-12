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

    context "Geo Spatial Complex Where" do

      let!(:home) do
        [-73.98,40.77]
      end

      describe "#near" do
        before do
          Bar.delete_all
          Bar.create_indexes
        end

        let!(:berlin) do
          Bar.create(:name => :berlin, :location => [ 52.30, 13.25 ])
        end

        let!(:prague) do
          Bar.create(:name => :prague, :location => [ 50.5, 14.26 ])
        end

        let!(:paris) do
          Bar.create(:name => :paris, :location => [ 48.48, 2.20 ])
        end

        it "returns the documents sorted closest to furthest" do
          Bar.where(:location.near => [ 41.23, 2.9 ]).should == [ paris, prague, berlin ]
        end

        it "returns the documents sorted closest to furthest" do
          Bar.where(:location.near => {:point=>[ 41.23, 2.9 ],:max => 20}).should == [ paris, prague, berlin ]
        end

        it "returns the documents sorted closest to furthest" do
          Bar.where(:location.near_sphere => [ 41.23, 2.9 ]).should == [ paris, prague, berlin ]
        end

        it "should find closest using rgeo point" do
          Bar.where(:location.near => paris.location).to_a.should == [paris, berlin, prague]
        end

      end

      context "#within" do

        context ":box, :polygon" do
          before do
            Bar.create_indexes
          end

          let!(:berlin) do
            Bar.create(:name => 'berlin', :location => [ 52.30, 13.25 ])
          end

          let!(:prague) do
            Bar.create(:name => 'prague',:location => [ 50.5, 14.26 ])
          end

          let!(:paris) do
            Bar.create(:name => 'prague',:location => [ 48.48, 2.20 ])
          end

          it "returns the documents within a box" do
            Bar.where(:location.within(:box) => [[ 47, 1 ],[ 49, 3 ]]).to_a.should == [ paris ]
          end

          it "returns the documents within a polygon" do
            Bar.where(:location.within(:polygon) => [[ 47, 1 ],[49,1.5],[ 49, 3 ],[46,5]]).should == [ paris ]
          end

          it "returns the documents within a center" do
            Bar.where(:location.within(:center) => [[ 47, 1 ],4]).should == [ paris ]
          end

          it "returns the documents within a center_sphere" do
            Bar.where(:location.within(:center_sphere) => [[ 48, 2 ],0.1]).should == [ paris ]
          end

        end

        context ":circle :center_sphere" do
          before do
            Bar.create_indexes
          end
          let!(:mile1) do
            Bar.create(:name => 'mile1', :location => [-73.997345, 40.759382])
          end

          let!(:mile3) do
            Bar.create(:name => 'mile2', :location => [-73.927088, 40.752151])
          end

          let!(:mile7) do
            Bar.create(:name => 'mile3', :location => [-74.0954913, 40.7161472])
          end

          let!(:mile11) do
            Bar.create(:name => 'mile4', :location => [-74.0604951, 40.9178011])
          end

          it "returns the documents within a center_sphere" do
            Bar.where(:location.within(:center_sphere) => {:point => home,:max => 2, :unit => :mi}).should == [ mile1 ]
          end

          it "returns the documents within a center_sphere" do
            Bar.where(:location.within(:center_sphere) => {:point => home,:max => 4, :unit => :mi}).should include(mile3)
          end

          it "returns the documents within a center_sphere" do
            Bar.where(:location.within(:center_sphere) => {:point => home,:max => 8, :unit => :mi}).should include(mile7)
          end

          it "returns the documents within a center_sphere" do
            Bar.where(:location.within(:center_sphere) => {:point => home,:max => 12, :unit => :mi}).should include(mile11)
          end
        end
      end
    end
    # HO
  end

  let(:within) do
    {
      :flat => Mongoid::Criterion::WithinSpatial.new(:key => :field, :operator => "near"),
      :sphere => Mongoid::Criterion::WithinSpatial.new(:key => :field, :operator => "nearSphere"),
    }
  end
  NEAR = {
      :flat =>
    {
      'Point'           => [[1,2],5],
      'Hash Point'      => {:point => [-73.98, 40.77], :max => 5},
      'Hash Point Unit' => {:point => [-73.98, 40.77], :max => 5, :unit => :km}
    },
      :sphere =>
    {
      'Point'           => [[1,2],5],
      'Hash Point'      => {:point => [-73.98, 40.77], :max => 5},
      'Hash Point Unit' => {:point => [-73.98, 40.77], :max => 5, :unit => :km}
    }
  }

  context "#to_mongo_query" do

    NEAR.each do |shape, points|
      points.each do |input_name,input|
        it "#{shape} should generate a query with #{input_name}" do
          within[shape].to_mongo_query(input).should be_a_kind_of(Hash)
        end
      end
    end
  end

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

    describe "#geo_near" do

    before do
      Bar.delete_all
      Bar.create_indexes
    end

    let!(:jfk) do
      Bar.create(:name => 'jfk', :location => [-73.77694444, 40.63861111 ])
    end

    let!(:lax) do
      Bar.create(:name => 'lax', :location => [-118.40, 33.94])
    end

    it "should work with specifying specific center and different location attribute on collction" do
      Bar.geo_near(lax.location, :spherical => true).should == [lax, jfk]
      Bar.geo_near(jfk.location, :spherical => true).should == [jfk, lax]
    end
    context 'option' do
      context ':num' do
        it "should limit number of results to 1" do
          Bar.geo_near(jfk.location, :num => 1).size.should == 1
        end
      end

      context ':maxDistance' do
        it "should get 1 item" do
          Bar.geo_near(lax.location, :spherical => true, :max_distance => 2465/Mongoid::Geospatial.earth_radius[:mi]).size.should == 1
        end
        it "should get 2 items" do
          Bar.geo_near(lax.location, :spherical => true, :max_distance => 2480/Mongoid::Geospatial.earth_radius[:mi]).size.should == 2
        end

      end

      context ':distance_multiplier' do
        it "should multiply returned distance with multiplier" do
          Bar.geo_near(lax.location, :spherical => true, :distance_multiplier=> Mongoid::Geospatial.earth_radius[:mi]).second.geo[:distance].to_i.should be_within(1).of(2469)
        end
      end

      context ':unit' do
        it "should multiply returned distance with multiplier" do
          pending
          Bar.geo_near(lax.location, :spherical => true, :unit => :mi).second.geo[:distance].to_i.should be_within(1).of(2469)
        end

        it "should convert max_distance to radians with unit" do
          Bar.geo_near(lax.location, :spherical => true, :max_distance => 2465, :unit => :mi).size.should == 1
        end

      end

      context ':query' do
        it "should filter using extra query option" do
          # two record in the collection, only one's name is Munich
          Bar.geo_near(jfk.location, :query => {:name => jfk.name}).should == [jfk]
        end
      end

    end

    context 'criteria chaining' do
      it "should filter by where" do
        Bar.where(:name => jfk.name).geo_near(jfk.location).should == [jfk]
        Bar.any_of({:name => jfk.name},{:name => lax.name}).geo_near(jfk.location).should == [jfk,lax]
      end

      it 'should skip 1' do
        Bar.skip(1).geo_near(jfk.location).size.should == 1
      end

      it 'should limit 1' do
        Bar.limit(1).geo_near(jfk.location).size.should == 1
      end
    end
  end

  context ':page' do
    before do
      Bar.delete_all
      Bar.create_indexes

      50.times do
        Bar.create({:location => [rand(360)-180,rand(360)-180]})
      end
    end

    context ":paginator :array" do
      [nil,1,2].each do |page|
        it "page=#{page} should have 25" do
          Bar.geo_near([1,1], :page => page).size.should == 25
        end
      end

      it "page=3 should have 0" do
        Bar.geo_near([1,1], :page => 20).size.should == 0
      end

      it "per_page=5" do
        Bar.geo_near([1,1], :page => 1, :per_page => 5).size.should == 5
      end
    end

    context ":paginator :kaminari" do
      let(:near) {Bar.geo_near([1,1], :page => 1)}

      it 'should have 50 Bars' do
        Bar.all.count.should == 50
      end

      it "should have limit_value" do
        near.limit_value.should == 25
      end

      # check results['results'] in GeoNearResults
      it 'should find 25 items' do
        near.size.should == 25
      end

      it "should have current_page" do
        near.current_page.should == 1
      end

      it "should have num_pages" do
        near.num_pages.should == 1
      end
    end
  end


    before do
    Bar.delete_all
    Bar.create_indexes

    50.times do |i|
      Bar.create!(:name => i.to_s, :location => [rand(358)-179,rand(358)-179])
    end
  end



  context ":paginator :array" do
    let(:bars) { Bar.geo_near([1,1]) }
    let(:sorted_bars) {
      bars = Bar.geo_near([1,1])
      bars.sort_by! {|b| b.name.to_i}
      bars
    }
    [nil,1,2].each do |page|
      it "page=#{page} should have 25" do
        bars.page(page).size.should == 25
      end
    end

    [1,2].each do |page|
      it "modified result should keep order after pagination" do
        sorted_bars.page(page).should == sorted_bars.slice((page-1)*25,25)
      end
    end

    { nil => 25, 20 => 20 , 30 => 20, 50 => 0}.each do |per, total|
      it "page=2 per=#{per} should have #{total}" do
        bars.per(per).page(2).size.should == total
        bars.page(2).per(per).size.should == total
      end
    end

    it "page=3 should have 0" do
      bars.page(3).size.should == 0
    end

    it "per=5" do
      bars.per(5).size.should == 5
    end

    it "page=10 per=5" do
      bars.per(5).page(10).should == bars[45..50]
    end

  end

  context ":paginator :kaminari" do
    let!(:near) {Bar.geo_near([1,1]).page(1)}
    it "should have current_page" do
      near.current_page.should == 1
    end

    it "should have num_pages" do
      near.total_entries.should == 50
      near.num_pages.should == 2
    end

    it "should have limit_value" do
      near.limit_value.should == 25
    end
  end


  context ":paginator :num_pages" do
    it "when total=55 per=10 ,num_pages should be 6" do
      5.times { |i| Bar.create(:name => i.to_s, :location => [rand(358)-179,rand(358)-179]) }
      Bar.geo_near([1,1]).per(10).num_pages.should    == 6
    end
  end
end
