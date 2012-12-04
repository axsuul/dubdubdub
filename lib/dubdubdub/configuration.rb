class DubDubDub::Configuration
  # Ignores all attempts to use proxies
  attr_accessor :ignore_proxy

  def initialize
    # Default config values
    self.ignore_proxy = false
  end
end