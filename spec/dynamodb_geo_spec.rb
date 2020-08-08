require 'spec_helper'
require 'dynamodb_geo'

describe DynamodbGeo do
  describe '.new' do
    it 'imported properly' do
      dynamo = DynamodbGeo.new(
        region:       'us-east-2',
        table_name:   'geo-test',
        profile_name: 'test'
      )
      expect(dynamo).to be_a DynamodbManager

      debugger;1
      puts 'foo'
    end
  end
end
