module TestAgent
  ##
  # Module contains config for test nodes
  # Default config path: /etc/chef-opennebula/config.yaml
  module TestAgentConfig
    extend TestAgentLogger

    @@config = {
        :opennebula_ip => '153.15.166.199',
        :end_point => 'http://153.15.166.199:2633/RPC2',
        :credentials => 'oneadmin:oneadmin',
        :sudo_pass => '11111111',
        :knife_config_path => '/etc/knife/.chef/knife.rb'
    }
    @@valid_config_keys = @@config.keys

    ##
    # Configure through hash.
    # @param opts [Hash] - config options.
    def self.configure(opts = {})
      opts.each {|k,v| @@config[k.to_sym] = v if @@valid_config_keys.include? k.to_sym}
    end

    ##
    # Configure through yaml file.
    # @param path_to_yaml_file [String] - path to config file.
    def self.configure_with(path_to_yaml_file)
      begin
        conf = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        warn("YAML configuration file couldn't be found. Using defaults."); return
      rescue Psych::SyntaxError
        warn('YAML configuration file contains invalid syntax. Using defaults.'); return
      end
      configure(conf)
    end

    ##
    # Get config hash
    # @return [Hash] - config.
    def config
      @@config
    end

    # Search for config in default location
    configure_with '/etc/chef-opennebula/config.yaml'
  end

end