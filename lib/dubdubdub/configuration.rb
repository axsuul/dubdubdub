class DubDubDub::Configuration
  # Ignores all attempts to use proxies
  attr_accessor :ignore_proxy

  def initialize
    # Default config values
    self.ignore_proxy = false
  end

  alias_method :ignore_proxy?, :ignore_proxy

  # Can be used as callable-setter when block provided.
  def proxy(&block)
    if block_given?
      @proxy = block
    else
      if @proxy.is_a? Proc
        @proxy.call
      else
        @proxy
      end
    end
  end

  def proxy=(proxy)
    @proxy = proxy
  end
end