module TestAgent
  ##
  # Module contains logging methods and is used to mixin that methods into classes.
  module TestAgentLogger
    @@logger = Logger.new($stdout)
    @@logger.level = Logger::DEBUG
    @@logger.datetime_format = '%d.%m.%Y %H:%M:%S'

    ##
    # Set One of logger levels.
    # @param level [Logger::DEBUG, INFO, WARN, ERROR, FATAL, UNKNOWN] debug lvl.
    # @return level passed to method.
    def self.log_level(level)
      @@logger.level = level
    end

    ##
    # Set logger IO pipe
    # @param stream [IO] Stream, where log will be put.
    def self.output_stream(stream)
      old_logger = @@logger
      @@logger = Logger.new stream
      @@logger.level = old_logger.level
      @@logger.datetime_format = '%d.%m.%Y %H:%M:%S'
    end

    ##
    # Define several logger methods (one for each log level)
    [:unknown, :fatal, :error, :warn, :info, :debug].each do |log_level|
      define_method(log_level) do |*args|
        @@logger.method(log_level).call(*args)
      end
    end
  end
end
