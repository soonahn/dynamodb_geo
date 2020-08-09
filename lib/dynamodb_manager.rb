require 'aws-sdk-dynamodb'
require 'geohash'
require 'store'

class DynamodbManager
  attr_accessor :client, :table_name, :hash_key, :range_key, :geohash_key, :geojson, :geohash_index, :hash_key_length, :local_area_size, :max_item_return
  def initialize(region:, table_name:, access_key_id: nil, secret_access_key: nil, profile_name: 'default', endpoint: nil)
    if access_key_id.nil? && secret_access_key.nil?
      access_key_id = ENV['AWS_ACCESS_KEY_ID']
      secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

      credentials = Aws::SharedCredentials.new(profile_name: profile_name).credentials if access_key_id.nil? && secret_access_key.nil?
    end
    credentials = Aws::Credentials.new(access_key_id, secret_access_key)

    @table_name      = table_name
    @hash_key        = 'hashkey'
    @range_key       = 'rangekey'
    @geohash_key     = 'geohash'
    @geojson         = 'geoJson'
    @geohash_index   = 'geohash-index'
    @hash_key_length = 4
    @local_area_size = 5
    @max_item_return = 10

    if endpoint
      @client = Aws::DynamoDB::Client.new(
        region:      region,
        credentials: credentials,
        endpoint:    endpoint
      )
    else
      @client = Aws::DynamoDB::Client.new(
        region:      region,
        credentials: credentials,
      )
    end
  end

  def table
    create_table unless @client.list_tables.table_names.include?(@table_name)

    @client.describe_table(table_name: @table_name)
  end

  def put_store(store)
    hash = store.geohash[0..(@local_area_size - 1)]
    json = {
      latitude:  store.lat,
      longitude: store.long,
      address:   store.address,
      city:      store.city,
      state:     store.state,
      zip:       store.zip,
      area_code: store.area_code,
      phone:     store.phone,
      name:      store.name,
    }
    put_point(hash, json)
  end

  def get_stores(lat, long)
    geohash    = Geohash.encode(lat, long, @local_area_size)
    hash       = geohash[0..(@hash_key_length - 1)]
    all_stores = []
    neighbours = Geohash.neighbours(hash)
    neighbours.unshift(hash)

    neighbours.each do |neighbour|
      resp = query(neighbour)
      resp.items.each do |item|
        all_stores << Store.new(item['geoJson'], item['geohash'])
      end
      break if all_stores.length >= max_item_return
    end

    # We got all the stores in the biggest possible area, we increase the hash by one and search around now
    neighbours = Geohash.neighbours(geohash)

    closest_stores     = all_stores.select { |store| store.geohash == geohash }
    surrounding_stores = (all_stores - closest_stores).select { |store| neighbours.include?(store.geohash) }
    remaining_stores   = all_stores - (closest_stores + surrounding_stores)

    return closest_stores + surrounding_stores + remaining_stores
  end

  private

  def query(hash)
    client.query({
      table_name: @table_name,
      index_name: @geohash_index,
      expression_attribute_values: {
        ':hash' => hash,
      },
      key_condition_expression: "#{@hash_key} = :hash",
    })
  end

  def put_point(hash, json)
    uuid = SecureRandom.uuid

    @client.put_item({
      table_name: @table_name,
      item: {
        @hash_key    => hash[0..(@hash_key_length - 1)],
        @range_key   => uuid,
        @geohash_key => hash,
        @geojson     => json
      }
    })
  end

  def create_table
    @client.create_table({
      attribute_definitions: [
        { attribute_name: @hash_key,    attribute_type: 'S' },
        { attribute_name: @range_key,   attribute_type: 'S' },
        { attribute_name: @geohash_key, attribute_type: 'S' }
      ],
      key_schema: [
        { attribute_name: @hash_key,  key_type: 'HASH' },
        { attribute_name: @range_key, key_type: 'RANGE' }
      ],
      local_secondary_indexes: [
        {
          index_name: @geohash_index,
          key_schema: [
            { attribute_name: @hash_key,    key_type: 'HASH' },
            { attribute_name: @geohash_key, key_type: 'RANGE' }
          ],
          projection: {
            projection_type: "ALL"
          }
        }
      ],
      provisioned_throughput: {
        read_capacity_units: 10,
        write_capacity_units: 5,
      },
      table_name: @table_name
    })
  end
end
