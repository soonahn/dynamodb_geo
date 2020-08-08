# DynamoDB_Geo
## DynamoDB
This is an attempt at storing and querying geohash data in DynamoDB.

We store objects in DynamoDB, when we query, we look for a customizable number of stored items by zooming out exactly one level.  
We return the objects in an attempt at the closest items first.

Items are searched as the following.

Given the lat, long we calculate a hash - assume 9x0qz.  We go up one level to 9x0q and calculate all neighbouring hashes.

    9x0p 9x0r 9x0x
    9x0n 9x0q 9x0w     => ["9x0q", "9x0r", "9x0x", "9x0w", "9x0t", "9x0m", "9x0j", "9x0n", "9x0p"]
    9x0j 9x0m 9x0t

From this, we ask DynamoDB starting from our own cell, going north, and wrapping clockwise for all objects in these cells up to a configurable number of objects.  
We then calculate the neighbours of our more local hash 9x0qz, and sort the results of the larger hashes using similar rules.

    9x0rn 9x0rp 9x0x0
    9x0qy 9x0qz 9x0wb  => ["9x0qz", "9x0rp", "9x0x0", "9x0wb", "9x0w8", "9x0qx", "9x0qw", "9x0qy", "9x0rn"]
    9x0qw 9x0qx 9x0w8

Using the same pattern as before (Middle -> North -> Clockwise), we sort the returned stores giving priority to the localization.

### Real talk
I know this isn't the most wonderful way to do this, I am still trying to think of something better.  Currently it uses up to 8 queries to DynamoDB, I'd like to cut that down to a single query.

There is a similar library written in Java and JS, but it uses Google S2 for the Geohashing, which has properties that allow them to do the zoom-out technique with a single query, however Google S2 does not exist as a C library (or Ruby library for that matter).  The other alternative is Uber H3, however it has the same issues of not being C, or Ruby.  

If we were able to use a unique but deterministic way to calcuate the range key based off of the hash key that would allow us to query every single larger cell in a single batch query.  I am currently thinking of more clever ways to do this - obviously I am open to suggestions.

## Objects
### DynamodbManager  

**Attributes**  
table_name:  
Sets the DynamoDB Table Name

hash_key:  
Sets the name of the primary hash attribute

range_key:  
Sets the name of the sort/range attribute

geohash_key:  
Sets the name of the localized hash attribute

geojson_key:  
Sets the name of the metadata attribute

hash_key_length:  
Sets size of the outer hash length

local_area_size:  
Sets the size of the inner hash length

max_item_return:  
Sets the max number of items to return

**Methods**  
Initialization

    Description: Creates a new DynamodbManager object.  Inputs are variables to your AWS account.
                 If access_key_id and secret_access_key are provided they are used.
                 If not provided, it falls back to ENV variables, then secret credential storage (profile name).
                 All arguments are keyword arguments
    Input:  region            => String
            table_name        => String
            access_key_id     => String
            secret_access_key => String
            profile_name      => 'default'
    Output: Aws::DynamoDB::Client

    #new => Object

Building and describing a DynamoDB Table

    Description: Shows the current configured table, or creates a table to configured as requested
    Input:
    Output: Aws::DynamoDB::Types::DescribeTableOutput

    #table => Object

Creating a new item

    Description: Inserts a new item
    Input:  Store
    Output: Aws::DynamoDB::Types::PutItemOutput

    #put_store => Object

Querying stores

    Description: Look for stores dependent on the input Lat, Long (as described above)
    Input:  Store
    Output: Array[Store]

    #get_stores => Array[Store]

### Store  

**Methods**  
Initialization

    Description: Initialization
    Input: Hash => {
      latitude  # Required
      longitude # Required
      address
      city
      state
      zip
      area_code
      phone
      name
      geohash # Calculated based on lat,long if not provided
    }
    Output: Store

    #new => Store

### DynamodbGeo  
This only exists as a quick and easy way to create a DynamodbManager.  The only method is `.new` and it passes all arguments along to DynamodbManager and returns an instance of DynamodbManager


## Geohashing
Includes a Geohash implimentation written in C  
<https://github.com/simplegeo/libgeohash>


### Methods
Encoding a Geohash

    Description: Takes in a latitude, longitude, and precision, and returns a geohash as a string
    Input:  latitude  => Number
            longitude => Number
            precision => Number
    Output: Geohash   => String

    Geohash.encode(lat, long, precision) => String


Decoding a Geohash

    Description: Takes in a hash, and returns a Geocoord
    Input:  Geohash  => String
    Output: Geocoord => Object

    Geohash.decode(hash) => Geocoord

Viewing all my neighbours

    Description: Takes in a Geohash and shows the surrounding 8 neighbours

                 Physical representation:
                 NW N NE       7 0 1
                 W  X E   =>   6 X 2
                 SW S SE       5 4 3

                 Flat representation:
                 N  NE E  SE S  SW W  NW
                 0  1  2  3  4  5  6  7
    Input:  Geohash => String
    Output: Array[Geocoord]

    Geohash.neighbours(hash) => Array[Geohash]

Viewing one of my neighbours

    Description: Takes in a Geohash and shows the neighbour in the cardinal direction
                 NORTH = 0
                 EAST  = 1
                 SOUTH = 2
                 WEST  = 3
    Input:  Geohash   => String
            Direction => Integer
    Output: Geohash

    Geohash.neighbour(hash) => Geohash

Get width and height about a specific precision

    Description: Takes in a precision value, returns the height and width of the box
    Input:  precision => Number
    Output: Dimension => Object

    Geohash.dimensions(precision) => Dimension

### Objects
#### Geocoord(Object) => attr_accessor: :latitude, :longitude, :north, :south, :east, :west, :dimension
#### Dimension(Object) => attr_accessor: :length, :width
