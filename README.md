Mongoid Geospatial
==================

A Mongoid Extension that simplifies the use of MongoDB spatial features.


** On beta again **

Removing some trash, improving and adding support for RGeo and GeoRuby.
Version 2+ is going to be beta testing, when it's ready I'll release v3,
So the major version stays the same as mongoid.


There are no plans to support MongoDB < 2.0
There are no plans to support Mongoid <= 2.0



Quick Start
-----------

This gem focus on (making helpers for) spatial features MongoDB has.
You can also use an external Geometric/Spatial alongside.

    # Gemfile
    gem 'mongoid_geospatial'


    # A place to illustrate Point, Line and Polygon
    class Place
      include Mongoid::Document
      include Mongoid::Geospatial

      field :name,     type: String
      field :location, type: Point, :spatial => true
      field :route,    type: Linestring
      field :area,     type: Polygon
    end


Geometry Helpers
----------------

We currently support GeoRuby and RGeo.
If you require one of those, a #to_geo method will be available to all
spatial fields, returning the external library corresponding object.
To illustrate:

    class Person
      include Mongoid::Document
      include Mongoid::Geospatial

      field :location, type: Point
    end

    me = Person.new(location: [8, 8])

    # Example with GeoRuby
    point.class # Mongoid::Geospatial::Point
    point.to_geo.class # GeoRuby::SimpleFeatures::Point

    # Example with RGeo
    point.class # Mongoid::Geospatial::Point
    point.to_geo.class # RGeo::Geographic::SphericalPointImpl


Configure
----------------

Assemble it as you need:

With RGeo

    Mongoid::Geospatial.use_rgeo
    # Optional
    # Mongoid::Geospatial.factory = RGeo::Geographic.spherical_factory

With GeoRuby

    Mongoid::Geospatial.use_georuby

Defaults (change if you know what you're doing)

    Mongoid::Geospatial.lng_symbol = :x
    Mongoid::Geospatial.lat_symbol = :y
    Mongoid::Geospatial.earth_radius = EARTH_RADIUS



Model Setup
-----------

You can create Point, Line and Polygon on your models:


```ruby
class River
  include Mongoid::Document
  include Mongoid::Geospatial

  field :name,              type: String
  field :length,            type: Integer
  field :average_discharge, type: Integer
  field :source,            type: Point,    spatial: true

  # set return_array to true if you do not want a hash returned all the time
  field :mouth,             type: Point,    spatial: {lat: :latitude, lng: :longitude, return_array: true }
  field :course,            type: Polygon

  # simplified spatial indexing
  # you can only index one point in mongodb version below 1.9
  # if you want something besides the defaults {bit: 24, min: -180, max: 180} just set index to the options on the index
  spatial_index :source

end
```

Use
---

Generate indexes on MongoDB:

```
rake db:mongoid:create_indexes
```


Before we manipulate the data mongoid_spatial handles is what we call points.

Points can be:

* an unordered hash with the lat long string keys defined when setting the field (only applies for setting the field)
* longitude latitude array in that order - [long,lat]
* an unordered hash with latitude key(:lat, :latitude) and a longitude key(:lon, :long, :lng, :longitude)
* an ordered hash with longitude as the first item and latitude as the second item
  This hash does not have include the latitude and longitude keys
  \*only works in ruby 1.9 and up because hashes below ruby 1.9 because they are not ordered
* anything with the method to_lng_lat that converts it to a [long,lat]
We store data in the DB as a [lng,lat] array then reformat when it is returned to you

```ruby
hudson = River.create(
  name: 'Hudson',
  length: 315,
  average_discharge: 21_400,
  # when setting array LONGITUDE MUST BE FIRST LATITUDE MUST BE SECOND
  # source: [-73.935833,44.106667],
  # but we can use hash in any order,
  # the default keys for latitude and longitude are :lat and :lng respectively
  source: {:lat => 44.106667, :lng => -73.935833},
  mouth: {:latitude => 40.703056, :longitude => -74.026667}
)

# now to access this spatial information we can now do this
hudson.source #=> {:lng => -73.935833, :lat => 44.106667}
hudson.mouth  #=> [-74.026667, 40.703056] # notice how this returned as a lng,lat array because return_array was true
# notice how the order of lng and lat were switched. it will always come out like this when using spatial.
# Also adds a handy distance function
hudson.distance_from(:source, [-74,40], {:unit=>:mi})

```
Mongoid Geo has extended all built in spatial symbol extensions

* near
  * River.where(:source.near => [-73.98, 40.77])
  * River.where(:source.near => [[-73.98, 40.77],5]) # sets max distance of 5
  * River.where(:source.near => {:point => [-73.98, 40.77], :max => 5}) # sets max distance of 5
  * River.where(:source.near(:sphere) => [[-73.98, 40.77],5]) # sets max distance of 5 radians
  * River.where(:source.near(:sphere) => {:point => [-73.98, 40.77], :max => 5, :unit => :km}) # sets max distance of 5 km
  * River.where(:source.near(:sphere) => [-73.98, 40.77])
* within
  * River.where(:source.within(:box) => [[-73.99756,40.73083], [-73.988135,40.741404]])
  * River.where(:source.within(:box) => [ {:lat => 40.73083, :lng => -73.99756}, [-73.988135,40.741404]])
  * River.where(:source.within(:polygon) => [ [ 10, 20 ], [ 10, 40 ], [ 30, 40 ], [ 30, 20 ] ]
  * River.where(:source.within(:polygon) => { a : { x : 10, y : 20 }, b : { x : 15, y : 25 }, c : { x : 20, y : 20 } })
  * River.where(:source.within(:center) => [[-73.98, 40.77],5])         # same format as near
  * River.where(:source.within(:center_sphere) => [[-73.98, 40.77],5])  # same format as near(:sphere)

One of the most handy features we have added is geo_near finder

```ruby
# accepts all criteria chains except without, only, asc, desc, order\_by
River.where(:name=>'hudson').geo_near({:lat => 40.73083, :lng => -73.99756})

# geo\_near accepts a few parameters besides a point
# :num = limit
# :query = where
# :unit - [:km, :m, :mi, :ft] - converts :max\_distance to appropriate values and automatically sets :distance\_multiplier. accepts
# :max\_distance - Integer
# :distance\_multiplier - Integer
# :spherical - true - To enable spherical calculations
River.geo_near([-73.99756,40.73083], :max_distance => 4, :unit => :mi, :spherical => true)
```


Mongo DB 1.9+ New Geo features
---------

Multi-location Documents v.1.9+

MongoDB now also supports indexing documents by multiple locations. These locations can be specified in arrays of sub-objects, for example:

```
> db.places.insert({ addresses : [ { name : "Home", loc : [55.5, 42.3] }, { name : "Work", loc : [32.3, 44.2] } ] })
> db.places.ensureIndex({ "addresses.loc" : "2d" })
```

Multiple locations may also be specified in a single field:

```
> db.places.insert({ lastSeenAt : [ { x : 45.3, y : 32.2 }, [54.2, 32.3], { lon : 44.2, lat : 38.2 } ] })
> db.places.ensureIndex({ "lastSeenAt" : "2d" })
```

By default, when performing geoNear or $near-type queries on collections containing multi-location documents, the same document may be returned multiple times, since $near queries return ordered results by distance. Queries using the $within operator by default do not return duplicate documents.

  v2.0
In v2.0, this default can be overridden by the use of a $uniqueDocs parameter for geoNear and $within queries, like so:

```
> db.runCommand( { geoNear : "places" , near : [50,50], num : 10, uniqueDocs : false } )
> db.places.find( { loc : { $within : { $center : [[0.5, 0.5], 20], $uniqueDocs : true } } } )
```

  Currently it is not possible to specify $uniqueDocs for $near queries
Whether or not uniqueDocs is true, when using a limit the limit is applied (as is normally the case) to the number of results returned (and not to the docs or locations).  If running a geoNear query with uniqueDocs : true, the closest location in a document to the center of the search region will always be returned - this is not true for $within queries.

In addition, when using geoNear queries and multi-location documents, often it is useful to return not only distances, but also the location in the document which was used to generate the distance.  In v2.0, to return the location alongside the distance in the geoNear results (in the field loc), specify includeLocs : true in the geoNear query. The location returned will be a copy of the location in the document used.

  If the location was an array, the location returned will be an object with "0" and "1" fields in v2.0.0 and v2.0.1.

```
> db.runCommand({ geoNear : "places", near : [ 0, 0 ], maxDistance : 20, includeLocs : true })
{
  "ns" : "test.places",
  "near" : "1100000000000000000000000000000000000000000000000000",
  "results" : [
    {
      "dis" : 5.830951894845301,
      "loc" : {
        "x" : 3,
        "y" : 5
      },
      "obj" : {
        "_id" : ObjectId("4e52672c15f59224bdb2544d"),
        "name" : "Final Place",
        "loc" : {
          "x" : 3,
          "y" : 5
        }
      }
    },
    {
      "dis" : 14.142135623730951,
      "loc" : {
        "0" : 10,
        "1" : 10
      },
      "obj" : {
        "_id" : ObjectId("4e5266a915f59224bdb2544b"),
        "name" : "Some Place",
        "loc" : [
          [
            10,
            10
          ],
          [
            50,
            50
          ]
        ]
      }
    },
    {
      "dis" : 14.142135623730951,
      "loc" : {
        "0" : -10,
        "1" : -10
      },
      "obj" : {
        "_id" : ObjectId("4e5266ba15f59224bdb2544c"),
        "name" : "Another Place",
        "loc" : [
          [
            -10,
            -10
          ],
          [
            -50,
            -50
          ]
        ]
      }
    }
  ],
  "stats" : {
    "time" : 0,
    "btreelocs" : 0,
    "nscanned" : 5,
    "objectsLoaded" : 3,
    "avgDistance" : 11.371741047435734,
    "maxDistance" : 14.142157540259815
  },
  "ok" : 1
}
```

The plan is to include this functionality in a future release. Please help out ;)

This Fork
---------

This fork is not backwards compatible with 'mongoid_spatial'.
This fork delegates calculations to the external libs and use Moped.

Change in your models:

    include Mongoid::Spacial::Document

to

    include Mongoid::Geospatial


And for the fields:


    field :source,  type: Array,    spacial: true

to

    field :source,  type: Point,    spatial: true


Beware the 't' and 'c' issue. It's spaTial.



Troubleshooting
---------------

**Mongo::OperationFailure: can't find special index: 2d**

Indexes need to be created. Execute command:

    rake db:mongoid:create_indexes


Thanks
------

* Thanks to Kristian Mandrup for creating the base of the gem and a few of the tests
* Thanks to CarZen LLC. for letting me release the code we are using

Contributing
------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
-----------

Copyright (c) 2011 Ryan Ong. See LICENSE.txt for
further details.
