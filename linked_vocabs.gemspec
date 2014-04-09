# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linked_vocabs/version'

Gem::Specification.new do |spec|
  spec.name          = "linked_vocabs"
  spec.version       = LinkedVocabs::VERSION
  spec.authors       = ["Tom Johnson"]
  spec.email         = ["johnson.tom@gmail.com"]
  spec.description   = 'Linked Data Controlled Vocabularies for ActiveFedora::Rdf.'
  spec.summary       = 'Linked Data Controlled Vocabularies for ActiveFedora::Rdf.'
  spec.license       = "APACHE2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency 'rake'
  spec.add_dependency 'active-fedora', '>=7.0.1'
  spec.add_dependency 'rdf', '>=1.1.2.1'
  spec.add_dependency 'sparql'
  spec.add_dependency 'sparql-client'

end
