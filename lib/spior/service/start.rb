# frozen_string_literal: true

module Spior
  # Interact with Spior::Tor and Spior::Iptables
  module Service
    module_function

    # Service.start should start Tor if not alrealy running
    # And start to redirect the local traffic with Iptables
    def start
      Tor::Start.new
      Iptables::Tor.new.run!
      Ipv6.new.block
    end
  end
end
