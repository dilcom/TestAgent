module TestAgent
  ##
  # Module contains config for test nodes
  # Default config path: /etc/chef-opennebula/config.yaml
  module TestAgentConfig
    extend TestAgentLogger

    ##
    # Config defaults
    @@config = {
      opennebula_ip: '127.0.0.1',
      end_point: 'http://127.0.0.1:2633/RPC2',
      credentials: 'oneadmin:oneadmin',
      local_sudo_pass: 'password',
      default_ssh_pass: 'password',
      default_interface_ip: '/^127.*/'
    }

    ##
    # Configure through hash.
    # @param opts [Hash] - config options.
    def self.configure(opts = {})
      valid_config_keys = @@config.keys
      opts.each do |k, v|
        @@config[k.to_sym] = v if valid_config_keys.include? k.to_sym
      end
    end

    ##
    # Configure through yaml file.
    # @param path_to_yaml_file [String] - path to config file.
    def self.configure_with(path_to_yaml_file)
      begin
        conf = YAML.load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        warn "YAML configuration file couldn't be found. Using defaults."
        return
      rescue Psych::SyntaxError
        warn 'YAML configuration file contains invalid syntax. Using defaults.'
        return
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
    configure_with '/etc/test-agent/config.yaml'
  end
end
