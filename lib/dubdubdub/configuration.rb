class DubDubDub::Configuration
  # Ignores all attempts to use proxies
  attr_accessor :ignore_proxies

  def initialize
    # Default config values
    self.ignore_proxies = false
  end
end