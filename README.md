# TestAgent

This Gem contains some adapters to OpenNebula and SikuliX interfaces to make possible fully automated GUI testing.

## Dependencies

Gem works with sikulix > 1.1.0.3 and OpenNebula ~> 3.8 gems. Of course you need Chef and OpenNebula server available and SikuliX installed.

## Installation

I'm not going to push the gem to RubyGems so you can download it and install locally:

    $ gem install --local TestAgent-0.1.1.gem

## Usage

Common way of usage:
```ruby
require 'TestAgent'
include TestAgent
# Share folder ./build-result/ via HTTP on some free port:
artifacts = SharedFolder.new "./build-result/"
# Get absollete external url to file named server-videowall-v1.0.1.rpm
pckg = artifacts.file_url("./serv*", /192/) 
#=> "http://192.168.12.3:32145/server-v1.0.1.rpm"

# Create two VM's: server and test-client0. 
# Bootstrap Chef client on server with role web-server
# and option package_url.
# Because of option keep_alive set to true, test-client0 will remain undeleted after end of testing
pool = TestPool.new(
{name: 'server', template: 'opensuse13.2', run_list: 'role[web-server]', options: "{package_url: #{pckg}}"},
{name: 'test-client0', template: 'win8.1', keep_alive: true} )

# Open VNC connection on test-client0
pool.init_vnc_screens('test-client0')
# Click on start button on test-client0 (SikuliX method, see http://www.sikulix.com/).
pool['test-client0'].click('start_button.png')
```
