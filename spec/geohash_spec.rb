require 'spec_helper'

# Quick note, I'm not actually testing if the Geohash is accurate or not.
# I'm assuming the C Lib I imported is doing that for me properly.
describe Geohash do
  describe '.encode' do
    it 'encodes' do
      encode = Geohash.encode(1,1,1)
      expect(encode).to be_a String
    end
  end

  describe '.decode' do
    it 'decodes' do
      decode = Geohash.decode('s')
      expect(decode).to be_a Geocoord
    end
  end

  describe '.neighbours' do
    it 'finds my neighbours' do
      neighbours = Geohash.neighbours('s')
      expect(neighbours.sample).to be_a String
      expect(neighbours.length).to be 8
    end
  end

  describe '.precision' do
    it 'calculates the dimensions for precision' do
      dimensions = Geohash.dimensions(1)
      expect(dimensions).to be_a Dimension
    end
  end
end
