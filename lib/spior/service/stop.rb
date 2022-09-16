# frozen_string_literal: true

module Spior
  module Service
    module_function

    def stop
      Tor.stop
      Iptables::Rules.new.restore
    end
  end
end
