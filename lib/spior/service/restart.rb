# frozen_string_literal: true

module Spior
  # Interact with Spior::Tor and Spior::Iptables
  module Service
    module_function

    def restart
      Service.stop(clean: false)
      Service.start
      Msg.p 'ip changed.'
    end
  end
end
