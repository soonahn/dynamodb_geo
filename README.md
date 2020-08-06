# DynamoDB-Geo


# Geohashing
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

Get width and height about a specific precision

    Description: Takes in a precision value, returns the height and width of the box
    Input:  precision => Number
    Output: Dimension => Object

    Geohash.dimensions(precision) => Dimension

#### Geocoord(Object) => attr_accessor: :latitude, :longitude, :north, :south, :east, :west, :dimension
#### Dimension(Object) => attr_accessor: :length, :width
