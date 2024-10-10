# frozen_string_literal: true

require 'nomansland'

module Spior
  # Interact with Spior::Tor and Spior::Iptables
  module Service
    module_function

    def restart
      case Nomansland.init?
      when :systemd
        Helpers.cmd('systemctl restart tor')
      when :openrc
        Helpers.cmd('/etc/init.d/tor restart')
      when :runit
        Helpers.cmd('sv restart tor')
      else
        puts 'No init found (systemd, openrc, runit)...'
      end
      Msg.p 'Tor restarting, ip changed.'
    end
  end
end
