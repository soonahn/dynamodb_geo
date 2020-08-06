Gem::Specification.new do |s|
  s.name           = 'dynamodb-geo'
  s.version        = '0.0.1'
  s.date           = '2020-08-04'
  s.summary        = 'A port of dynamodb-geo to Ruby'
  s.description    = 'A port of dynamodb-geo to Ruby'
  s.authors        = ['Justin Ahn']
  s.email          = 'justin@soonahn.ca'
  s.homepage       = 'https://rubygems.org/gems/dynamodb-geo'
  s.license        = 'Beerware'
  s.files          = Dir.glob('ext/*') + ['lib/geohash.rb']
  s.platform       = Gem::Platform::RUBY
  s.extensions << 'ext/dynamodb-geo/extconf.rb'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rake-compiler'
end
