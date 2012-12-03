class DubDubDub
  # Version
  VERSION = "0.0.1"

  attr_accessor :client

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
require File.expand_path(File.dirname(__FILE__) + '/dubdubdub/client')