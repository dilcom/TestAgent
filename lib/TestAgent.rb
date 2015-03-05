# External dependencies
require 'yaml'
require 'sikulix'
require 'OpenNebula'
require 'socket'
require 'pathname'
require 'logger'
require 'time'

module TestAgent
  extend Sikulix
end

# Internal modules and classes
require 'TestAgent/version'
require 'TestAgent/helpers/TestAgentLogger.rb'
require 'TestAgent/helpers/TestAgentConfig.rb'
require 'TestAgent/main/SharedFolder'
require 'TestAgent/main/TestNode'
require 'TestAgent/main/TestPool'
