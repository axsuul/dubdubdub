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
      # If true and we have a proxy list, use a random one from the list
      # or ignore and don't use a proxy at all
      if options[:proxy] == true
        if DubDubDub.proxies and DubDubDub.proxies.is_a?(Array) and DubDubDub.proxies.any?
          self.proxy = DubDubDub.proxies.sample
        else
          raise DubDubDub::Exception, "No proxies have been specified!" unless DubDubDub.configuration.ignore_proxies
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
    "#{proxy_host}:#{proxy_port}"
  end

  def proxy?
    return false if DubDubDub.configuration.ignore_proxies

    !!proxy
  end

  # Returns a Net::HTTP object
  def net_http(uri)
    raise ArgumentError, "A URI must be provided!" unless uri.kind_of? URI::Generic

    net_http_class = if proxy?
      Net::HTTP.Proxy(proxy_host, proxy_port, proxy_user, proxy_password)
    else
      Net::HTTP
    end

    http = net_http_class.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE  # ssl certificate doesn't need to be verified, otherwise a OpenSSL::SSL::SSLError might get thrown
    http.use_ssl = true if uri.scheme == "https"

    http
  end

  # Returns a RestClient::Resource
  def rest_client_resource(url)
    options = {}
    options[:proxy] = proxy if proxy?

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
    mechanize.get(url, *args)
  end

  # Follow a url to the end until it can no longer go any further
  # Even if it times out, it will return the url that it times out on!
  def follow_url(url, options = {}, &block)
    default_options = { limit: 20, attempts: 5, timeout: 5 }
    options = default_options.merge(options)

    at_base = false
    previous_uri = nil  # Keep track of previous uri for relative path redirects
    response = nil
    user_agents = [
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.79 Safari/535.11',
      ''
    ]
    urls = []   # the url history

    raise ArgumentError if options[:until] and !options[:until].is_a?(Proc)

    # before we begin, let's yield the initial url if a block was given
    yield(url) if block_given?

    options[:limit].downto(1).each do |i|
      begin
        at_base = true if options[:until] and options[:until].call(url)

        uri = URI.parse(url)
        net_http = net_http(uri)
        at_base = true unless uri.respond_to?(:request_uri)   # make sure its a proper url

        unless at_base
          request = Net::HTTP::Get.new(uri.request_uri)
          request_attempts = 0

          # we make a certain amount of attempts in case we timeout
          while request_attempts < options[:attempts]
            begin
              request_attempts += 1

              # Don't let the request take too long
              response = Timeout::timeout(options[:timeout]) do
                net_http.request(request)
              end

              break   # if it reaches this, that means the request was successful do break out!
            # If any of these exceptions are thrown, it has timed out, so keep trying depending on how many attempts we have
            rescue Timeout::Error, Errno::ETIMEDOUT, Errno::EHOSTUNREACH
              # do another attempt if we are allowed one, or stop
              at_base = true and break if request_attempts == options[:attempts]
            rescue SocketError  # doesn't exist
              at_base = true and break
            end
          end

          case response
          when Net::HTTPSuccess then at_base = true
          when Net::HTTPRedirection then url = response['location']
          when Net::HTTPForbidden then raise DubDubDub::Forbidden
          # Couldn't resolve, just return url
          else at_base = true
          end if response
        end

      # If any of these exceptions get thrown, return the current url
      rescue SocketError, EOFError
        at_base = true
      rescue URI::InvalidURIError
        return url  # Just return it
      end

      urls << url

      break if at_base

      previous_uri = uri   # Keep track of previous uri
      yield(url) if block_given?
    end

    end_uri = URI.parse(url)

    # If there is no host, it's due to a relative 301 redirect. Use previous uri's host, port, etc
    if !end_uri.host and previous_uri
      end_uri = previous_uri
      end_uri.path = url
    end

    end_uri.to_s
  end
end