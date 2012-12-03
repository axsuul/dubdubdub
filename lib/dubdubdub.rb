# require 'dubdubdub/client'

class DubDubDub
  # Version
  VERSION = "0.0.1"

  attr_accessor :client

  def initialize
    @client = DubDubDub::Client.new
  end

  def browse

  end

  def crawl

  end

  def follow_url(*args, &block)
    @client.follow_url(*args, &block)
  end
end

require 'dubdubdub/error'
require 'dubdubdub/client'