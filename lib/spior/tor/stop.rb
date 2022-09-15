# frozen_string_literal: true

module Spior
  module Tor
    module_function

    # Stop Tor service on your distribution (linux)
    # It also kill previous instance run by Spior
    def stop
      old_pid = `pgrep -f "tor -f /tmp/torrc*"`.chomp

      if old_pid != ''
        Msg.p "Found old pid > #{old_pid}, killing it..."
        Helpers::Exec.new('kill').run("-9 #{old_pid}")
      end

      case Nomansland.init?
      when :systemd
        Msg.p 'Stopping Tor with Systemd...'
        Helpers::Exec.new('systemctl').run('stop tor')
      when :runit
        Msg.p 'Stopping Tor with Runit...'
        Helpers::Exec.new('sv').run('stop tor')
      when :openrc
        Msg.p 'Stopping Tor with Openrc...'
        Helpers::Exec.new('/etc/init.d/tor').run('stop')
      else
        Msg.report 'Don\'t known how to stop Tor on your system.'
      end
    end
  end
end
