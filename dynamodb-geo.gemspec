$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'dynamodb-geo/version'

Gem::Specification.new do |s|
  s.name             = 'dynamodb-geo'
  s.version          = '0.0.1'
  s.date             = '2020-08-04'
  s.description      = 'A port of dynamodb-geo to Ruby. Includes a geohash module.'
  s.summary          = "dynamodb-gep-#{DynamodbGeo::Version::STRING}"
  s.authors          = ['Justin Ahn']
  s.email            = 'justin@soonahn.ca'
  s.homepage         = 'https://rubygems.org/gems/dynamodb-geo'
  s.license          = 'Beerware'
  s.files            = `git ls-files -- {lib,ext}/*`.split("\n")
  s.files           += ['LICENSE.md']
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.extra_rdoc_files = [ "README.md" ]
  s.platform         = Gem::Platform::RUBY
  s.extensions << 'ext/dynamodb-geo/extconf.rb'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rake-compiler'
  s.add_runtime_dependency 'aws-sdk-dynamodb', '~> 1'
  s.add_runtime_dependency 'aws-sdk-dynamodbstreams', '~> 1'
end
