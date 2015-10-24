# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'str_genetic_algorithm'
  spec.version       = '0.0.1'
  spec.authors       = ['Evan Rolfe']
  spec.email         = ['evanrolfe@gmail.com']
  spec.summary       = 'Uses a genetic algorithm to evolve a random string to a target string'
  spec.homepage      = 'https://github.com/evanrolfe/str_genetic_algorithm'
  spec.license       = 'MIT'
  spec.description   = 'A simple genetic algorithm to evolve a population of strings using the edit distance from the target string as the fitness function.'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'rubocop', '~> 0.34'
end
