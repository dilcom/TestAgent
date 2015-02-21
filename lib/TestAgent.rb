# External dependencies
require 'yaml'
require 'sikulix'
require 'OpenNebula'
require 'socket'
require 'pathname'
require 'logger'

# Internal modules and classes
require 'TestAgent/version'
require 'TestAgent/helpers/TestAgentLogger.rb'
require 'TestAgent/helpers/TestAgentConfig.rb'
require 'TestAgent/main/SharedFolder'
require 'TestAgent/main/TestPool'