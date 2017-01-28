# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'call_graph/version'

Gem::Specification.new do |spec|
  spec.name          = 'call_graph'
  spec.version       = CallGraph::VERSION
  spec.authors       = ['James Moriarty']
  spec.email         = ['james.moriarty@rea-group.com']

  spec.summary       = 'Capture execution and create dependency graphs.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency             'binding_of_caller'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
