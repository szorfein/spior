# frozen_string_literal: true

require 'nomansland'
require 'tempfile'

module Spior
  # Module Spior::Tor used to start/stop/restart Tor on the system.
  module Tor
    # start should start the Tor service on your distribution
    class Start
      def initialize
        tmp_file = Tempfile.new('torrc')

        Config.new(tmp_file).generate

        nomansland
      end

      protected

      def nomansland
        case Nomansland.init?
        when :systemd
          start_systemd
        when :openrc
          start_openrc
        when :runit
          start_runit
        else
          Msg.report "Don't known yet how to start Tor for your system."
        end
      end

      private

      def start_systemd
        state = `systemctl is-active tor`.chomp
        return if state == 'active'

        Msg.p 'Starting Tor with Systemd...'
        Helpers.cmd('systemctl start tor')
      end

      def start_openrc
        Msg.p 'Starting Tor with OpenRC...'
        Helpers.cmd('/etc/init.d/tor start')
      end

      def start_runit
        Msg.p 'Starting Tor with Runit...'
        if File.exist? '/var/service/tor'
          Helpers.cmd('sv start tor')
        else
          Helpers.cmd('ln -s /etc/sv/tor /var/service/tor')
        end
      end
    end
  end
end
