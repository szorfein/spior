# frozen_string_literal: true

module Spior
  module Service
    module_function

    def start
      Tor.start
      Iptables::Tor.new.run!
    end
  end
end
