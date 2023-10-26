# frozen_string_literal: true

module Spior
  # Interact with Spior::Tor and Spior::Iptables
  module Service
    module_function

    def stop(clean: true)
      Tor::Stop.new
      Iptables::Rules.new.restore if clean
      Ipv6.new.allow if clean
    end
  end
end
