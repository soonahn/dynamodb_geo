require 'geohash/geohash_wrapper'

class Geohash
  class << self
    def decode(hash)
      Geocoord.new(wrap_decode(hash)).freeze
    end

    def dimensions(precision)
      Dimension.new(dimensions_for_precision(precision)).freeze
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
  attr_accessor :height, :width

  def initialize(geobox)
    @height = geobox['height']
    @width  = geobox['width']
  end
end
