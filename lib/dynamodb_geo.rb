require 'dynamodb_manager'

module DynamodbGeo
  class << self
    def new(region:, table_name:, access_key_id: nil, secret_access_key: nil, profile_name: 'default')
      DynamodbManager.new(
        region: region,
        access_key_id: access_key_id,
        secret_access_key: secret_access_key,
        profile_name: profile_name,
        table_name: table_name
      )
    end
  end
end
