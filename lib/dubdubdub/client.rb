require 'open-uri'

class DubDubDub::Client
  def initialize
    # TODO
  end

  # Returns a Net::HTTP object
  def net_http(uri)
    raise ArgumentError unless uri.is_a? URI::HTTP

    http = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE  # ssl certificate doesn't need to be verified, otherwise a OpenSSL::SSL::SSLError might get thrown
    http.use_ssl = true if uri.scheme == "https"

    http
  end

  # Follow a url to the end until it can no longer go any further
  # Even if it times out, it will return the url that it times out on!
  def follow_url(url, options = {}, &block)
    default_options = { limit: 20, attempts: 5, timeout: 5 }
    options = default_options.merge(options)

    at_base = false
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
          # Couldn't resolve, just return url
          else at_base = true
          end if response
        end

      # If any of these exceptions get thrown, return the current url
      rescue SocketError, URI::InvalidURIError, EOFError
        at_base = true
      end

      urls << url

      break if at_base
      yield(url) if block_given?
    end

    url
  end
end