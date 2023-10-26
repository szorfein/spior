# frozen_string_literal: true

module Spior
  # Module Spior::Tor used to start/stop/restart Tor on the system.
  module Tor
    # Stop Tor service on your distribution (linux)
    # It also kill previous instance run by Spior
    class Stop
      def initialize
        old_pid = `pgrep -f "tor -f /tmp/torrc*"`.chomp

        if old_pid != ''
          Msg.p "Found old pid > #{old_pid}, killing it..."
          Helpers::Exec.new('kill').run("-9 #{old_pid}")
        end

        nomansland
      end

      protected

      def nomansland
        case Nomansland.init?
        when :systemd
          stop_systemd
        when :runit
          stop_runit
        when :openrc
          stop_openrc
        else
          Msg.report 'Don\'t known how to stop Tor on your system.'
        end
      end

      private

      def stop_systemd
        Msg.p 'Stopping Tor with Systemd...'
        Helpers::Exec.new('systemctl').run('stop tor')
      end

      def stop_runit
        Msg.p 'Stopping Tor with Runit...'
        Helpers::Exec.new('sv').run('stop tor')
      end

      def stop_openrc
        Msg.p 'Stopping Tor with Openrc...'
        Helpers::Exec.new('/etc/init.d/tor').run('stop')
      end
    end
  end
end
