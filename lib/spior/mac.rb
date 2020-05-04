require "pathname"
require_relative "msg"

module Spior
  module MAC
    extend self

    def randomize(interface)
      @network_int = interface
      check_dep
      system("deceitmac --interface #{@network_int} --random --dhcpcd --tor --no-banner")
    end

    private

    def check_dep
      if ! Pathname.new("/usr/local/bin/deceitmac") then
        Msg.error "deceitmac is not installed, please, exec spior --install"
        exit(-1)
      end
    end
  end
end
