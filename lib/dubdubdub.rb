# require 'dubdubdub/client'

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
      send(method, *args, &block)
    end
  end
end

require 'dubdubdub/exceptions'
require 'dubdubdub/client'