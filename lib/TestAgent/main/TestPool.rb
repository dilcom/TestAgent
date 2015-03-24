module TestAgent
  ##
  # Contains several testing nodes
  # and offers Sikulix VNC screens initializing
  class TestPool
    include TestAgentConfig
    include TestAgentLogger

    ##
    # Initialize pool with several nodes
    # @param args several hashes each containing:
    #   Necessary fields:
    #     name - node name (should be unique for that pool)
    #     template - OpenNebula template name
    #   Optional fields:
    #     runlist - chef run list
    #     options - options passed to chef
    #     keep_alive - keep vm alive after end of testing
    # @example
    #   TestPool.new({name: "node1", template: "qwerty_temp", run_list: "recipe[webserver]"})
    #   TestPool.new({name: "node1", template: "temp"}, {name: "node2", template: "temp"})
    def initialize(*args)
      @nodes = {}
      self.<<(*args)
    end

    ##
    # Standard each method
    # @param regexp [Regexp] used to choose nodes (name =~ regexp) to run each on
    def each(regexp = nil)
      return nil unless block_given?
      @nodes.each do |name, node|
        yield(name, node) if !regexp || name =~ regexp
      end
    end

    ##
    # Bootstrap some nodes if they contain necessary params
    def bootstrap(nodes)
      nodes.each do |node|
        if node[:run_list]
          @nodes[node[:name]].bootstrap(run_list: node[:run_list], data: node[:options])
        end
      end
    end

    ##
    # Initialize pool with several nodes
    # @param nodes several hashes each containing:
    #   Necessary fields:
    #     name - node name (should be unique for that pool)
    #     template - OpenNebula template name
    #   Optional fields:
    #     runlist - chef run list
    #     options - options passed to chef
    #     keep_alive - keep vm alive after end of testing
    # @example
    #   TestPool.new({name: "node1", template: "qwerty_temp", run_list: "recipe[webserver]"})
    #   TestPool.new({name: "node1", template: "temp"}, {name: "node2", template: "temp"})
    def <<(*nodes)
      tmp = nodes
      tries_left = 3
      until tmp.empty? || tries_left <= 0
        tmp.first(2).each do |hash|
          @nodes[hash[:name]] = TestNode.new(hash[:name], hash[:template], hash[:keep_alive])
        end
        tmp.select! do |hash|
          node = @nodes[hash[:name]]
          !node || !node.vm_ok?
        end
        tries_left -= 1
      end
      bootstrap(nodes)
      self
    end

    ##
    # Gets a node from hash
    # @param name [String] - node name
    def [](name)
      @nodes[name.to_s]
    end

    ##
    # Initializes Sikulix VNC screens on chosen nodes
    # @param names [String] names of nodes to initialize VNC screens on them
    #   if no names passed will initialize screen on every node in pool
    # @example
    #   init_vnc_screens
    #   init_vnc_screens "node1", "node5", "node9"
    def init_vnc_screens(*names)
      nodes = names.size == 0 ? @nodes : @nodes.select { |name| names.include? name }
      return false if @vnc_initialized
      address_array = nodes.map do |_name, el|
        a = "#{config[:opennebula_ip]}:#{5900 + el.id}"
        debug "Node address: #{a}"
        a
      end
      return false if address_array.empty?
      initVNCPool(*address_array)
      nodes.each_with_index do |(_name, el), index|
        el.vnc_screen = $VNC_SCREEN_POOL[index]
      end
      @vnc_initialized = true
    end

    def free_pool
      freeVNCPool
      each { |name, vm| vm.delete_vm }
    end
  end
end
