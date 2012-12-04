class DubDubDub
  # Version
  VERSION = "0.2.5"

  attr_accessor :client

  class << self
    attr_accessor :proxies
  end

  def self.configure
    yield(configuration)
  end

  # Returns DubDubDub::Configuration or instantiates if doesn't exit
  def self.configuration
    @configuration ||= DubDubDub::Configuration.new
  end

   # Reset configuration back to defaults, useful for testing
  def self.reset_configuration!
    @configuration = nil
  end

  def initialize(options = {})
    @client = DubDubDub::Client.new(options)
  end

  # Redirect methods to client
  def method_missing(method, *args, &block)
    if @client.respond_to?(method)
      @client.send(method, *args, &block)
    else
      super
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/dubdubdub/exceptions')
require File.expand_path(File.dirname(__FILE__) + '/dubdubdub/configuration')
require File.expand_path(File.dirname(__FILE__) + '/dubdubdub/client')