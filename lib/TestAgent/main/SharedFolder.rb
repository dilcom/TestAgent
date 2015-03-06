module TestAgent
  ##
  # Object of class represents
  # a folder shared via HTTP
  class SharedFolder
    include TestAgentConfig
    include TestAgentLogger

    ##
    # Kills process running HTTP server
    def kill
      unless @pid
        warning "Server isn't running. Can't stop."
        return
      end
      Process.kill('TERM', @pid)
      @pid = nil
    end

    def find_free_port
      s = Socket.new(:INET, :STREAM, 0)
      s.bind(Addrinfo.tcp('0.0.0.0', 0))
      port = s.local_address.ip_port
      s.close
      port
    end

    ##
    # Starts a HTTP server sharing folder
    # @param path [String] scpecifies path to folder you want to share
    # @param port [Int] port which should be used to bind http server
    def start(path, port = find_free_port)
      if @pid
        warning "Server already running. Can't start."
        return
      end
      @port = port
      @path = path
      @pid = Process.spawn("jruby -run -e httpd #{@path} -p #{@port}")
    end

    ##
    # Creates and starts a HTTP server sharing folder
    # @param args first param - path to folder, second - port
    def initialize(*args)
      start(*args)
      ObjectSpace.define_finalizer(self, proc { kill })
    end

    ##
    # Creates a HTTP url to some file inside folder
    # @param file_path [String] path to file relative to shared directory
    # @param ip_regexp [Regexp] regular expression used to choose net interface
    # @example
    #   file_url('./lib/*.rb')
    def file_url(file_path, ip_regexp = config[:default_interface_ip])
      ip = Socket.ip_address_list.detect { |int| int.ip_address =~ ip_regexp }.ip_address
      files = Dir.glob(File.expand_path(@path) + '/' + file_path)
      if files.size < 1
        warn "No file found by path #{file_path}"
        return
      end
      absolute_path = Pathname.new(files[0])
      project_root  = Pathname.new(File.expand_path(@path))
      relative = absolute_path.relative_path_from(project_root)
      "http://#{ip}:#{@port}/#{relative}"
    end

    private :find_free_port
  end
end
