# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'TestAgent/version'

Gem::Specification.new do |spec|
  spec.name          = 'TestAgent'
  spec.version       = TestAgent::VERSION
  spec.authors       = ['dilcom']
  spec.email         = ['dilcom3107@gmail.com']
  spec.homepage      = 'http://example.com'

  spec.summary       = 'Test agent for GUI testing'
  spec.description   = 'Gem provides basic classes to represent OpenNebula
                        virtual machines as node for gui testing.
                        Nodes are configurable with Chef and testing may be
                        performed with SikuliX tool via VNC.
                        Gem is written for OpenNebula gem v3.8!
                        Using newer version will require some changes
                        in vm deletion process (delete instead finalize).'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'sikulix', '~>1.1'
  spec.add_runtime_dependency 'opennebula-oca', '~>3.8'
end
