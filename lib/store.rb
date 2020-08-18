class Store
  attr_accessor :lat, :long, :address, :city, :state, :zip, :area_code, :phone, :name, :geohash, :uuid
  def initialize(store_data)
    @lat       = store_data[:latitude]
    @long      = store_data[:longitude]
    @address   = store_data[:address]
    @city      = store_data[:city]
    @state     = store_data[:state]
    @zip       = store_data[:zip]
    @area_code = store_data[:area_code]
    @phone     = store_data[:phone]
    @name      = store_data[:name]
    @geohash   = store_data[:geohash] || Geohash.encode(lat, long, 10)
    @uuid      = store_data[:uuid]
  end
end
