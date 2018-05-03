lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weeb/ver'

Gem::Specification.new do |gem|
  gem.name          = 'weeb'
  gem.version       = WeebSh::VERSION
  gem.date          = '2018-02-05'
  gem.authors       = ['Snazzah']
  gem.email         = 'suggesttosnazzy@gmail.com'
  gem.summary       = 'A gem that utilizes the weeb.sh API.'
  gem.description   = 'A gem that utilizes the weeb.sh API.'
  gem.files         = Dir['lib/**/*.rb']
  gem.homepage      = 'https://github.com/Snazzah/weeb.rb'
  gem.license       = 'MIT'

  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rubocop', '0.49.1'

  gem.add_dependency 'rest-client'
end
