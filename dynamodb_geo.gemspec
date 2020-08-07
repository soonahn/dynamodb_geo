require 'dynamodb_geo/version'

Gem::Specification.new do |s|
  s.name             = 'dynamodb_geo'
  s.version          = "#{DynamodbGeo::Version::STRING}"
  s.date             = '2020-08-04'
  s.description      = 'A port of dynamodb_geo to Ruby. Includes a geohash module.'
  s.summary          = "dynamodb_geo-#{DynamodbGeo::Version::STRING}"
  s.authors          = ['Justin Ahn']
  s.email            = 'justin@soonahn.ca'
  s.license          = 'Beerware'
  s.files            = `git ls-files -- {lib,ext}/*`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.extra_rdoc_files = [ "README.md" ]
  s.platform         = Gem::Platform::RUBY
  s.extensions << 'ext/geohash_wrapper/extconf.rb'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rake-compiler'
  s.add_runtime_dependency 'aws-sdk-dynamodb', '~> 1'
  s.add_runtime_dependency 'aws-sdk-dynamodbstreams', '~> 1'
  s.metadata = {
    'source_code_uri' => 'https://github.com/JA-Soonahn/dynamodb_geo',
  }

end
