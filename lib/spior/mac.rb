require "pathname"
require_relative "msg"

module Spior
  module MAC
    def self.randomize(interface)
      @network_int = interface
      system("deceitmac --interface #{@network_int} --random --dhcpcd --tor --no-banner")
    end
  end
end
