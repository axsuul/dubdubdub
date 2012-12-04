require 'net/http'
require 'nokogiri'
require 'mechanize'

class DubDubDub::Client
  attr_accessor :proxy_host, :proxy_port, :proxy_user, :proxy_password

  def initialize(options = {})
    default_options = {
      proxy: false
    }

    options = default_options.merge(options)

    # If we want to use a proxy
    if options[:proxy]
      # If true, refer to global proxy config
      if options[:proxy] == true
        unless DubDubDub.configuration.ignore_proxy?
          proxy = DubDubDub.configuration.proxy

          raise ArgumentError, "No proxy has been configured or provided!" if proxy.nil?

          self.proxy = proxy
        end
      # Otherwise, it should be a proxy url
      else
        self.proxy = options[:proxy]
      end
    end
  end

  def proxy_port=(port)
    @proxy_port = port.to_i
  end

  def proxy=(url)
    host, port = url.split(":")

    port = 80 unless port
    self.proxy_host = host
    self.proxy_port = port
  end

  def proxy
    "#{proxy_host}:#{proxy_port}" if proxy_host and proxy_port
  end

  def proxy?
    return false if DubDubDub.configuration.ignore_proxy?

    !!proxy
  end

  # Returns a RestClient::Resource
  def rest_client_resource(url)
    options = {}
    options[:proxy] = "http://#{proxy}" if proxy?

    RestClient::Resource.new(url, options)
  end

  # Returns a Mechanize instance (agent)
  def mechanize
    agent = Mechanize.new
    agent.set_proxy(proxy_host, proxy_port) if proxy?

    agent
  end

  # Perform a GET request
  def get(url, *args)
    rest_client_resource(url).get(*args)
  end

  # Perform a POST request
  def post(url, *args)
    rest_client_resource(url).post(*args)
  end

  # Perform a DELETE request
  def delete(url, *args)
    rest_client_resource(url).delete(*args)
  end

  # Helper method to crawl by using a GET request via RestClient
  def crawl(url, *args)
    response = get(url, *args)

    Nokogiri::HTML(response.body)
  end

  # Helper method to browse by using a GET request via Mechanize
  def browse(url, *args)
    handle_net_http_exceptions do
      handle_mechanize_exceptions do
        mechanize.get(url, *args)
      end
    end
  end

  # Follow a URL to the end
  def follow(url)
    browse(url).uri.to_s
  end

  private
  def handle_net_http_exceptions(&block)
    begin
      yield
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::EHOSTUNREACH
      raise DubDubDub::ResponseError.new(e, 408)  # Timeout
    rescue SocketError, EOFError => e
      raise DubDubDub::ResponseError.new(e, 404)  # Not found
    end
  end

  def handle_mechanize_exceptions(&block)
    begin
      yield
    rescue Mechanize::ResponseCodeError => e
      raise DubDubDub::ResponseError.new(e, e.response_code)
    end
  end
end