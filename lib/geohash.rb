require 'geohash/geohash_wrapper'
require 'byebug'

class Geohash
  class << self
    def decode(hash)
      Geocoord.new(wrap_decode(hash))
    end
  end
end

class Geocoord
  attr_accessor :latitude, :longitude, :north, :south, :east, :west, :dimension
  def initialize(geocoord)
    @latitude  = geocoord['latitude']
    @longitude = geocoord['longitude']
    @north     = geocoord['north']
    @south     = geocoord['south']
    @east      = geocoord['east']
    @west      = geocoord['west']
    @dimension = Dimension.new(geocoord['dimension'])
  end
end

class Dimension
  attr_accessor :length, :width

  def initialize(geobox)
    length = geobox['length']
    width  = geobox['width']
  end
end
