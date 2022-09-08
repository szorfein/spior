require 'nomansland'

module Spior
  module Service
    module_function

    def start
      case Nomansland.init?
      when :systemd
        Msg.p "Detect a Systemd system, starting Tor..."
        state = `systemctl is-active tor`.chomp
        unless state == 'active'
          Helpers::Exec.new("systemctl").run("start tor")
        end
      when :runit
        Msg.p "Detect a Runit system, starting Tor..."
        unless File.exist? '/var/service/tor'
          Helpers::Exec.new('ln').run('-s /etc/sv/tor /var/service/tor')
        end
      when :openrc
        Msg.p "Detect an Openrc system, starting Tor..."
        Helpers::Exec.new('/etc/init.d/tor').run('start')
      else
        Msg.report "Don't known yet how to start Tor for your system."
      end
    end
  end
end
