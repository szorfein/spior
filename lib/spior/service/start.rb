# frozen_string_literal: true

module Spior
  module Service
    module_function

    # Service.start should start Tor if not alrealy running
    # And start to redirect the local traffic with Iptables
    def start
      Dep.check
      Tor.start
      Iptables::Tor.new.run!
    end
  end
end
