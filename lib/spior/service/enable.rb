# frozen_string_literal: true

require 'nomansland'

module Spior
  # Service make Spior persistent using services on system like iptables and tor
  module Service
    # Enable the Tor redirection when you boot your system
    #
    # It should use and enable the services:
    # + tor
    # + iptables
    class Enable
      def initialize
        case Nomansland.distro?
        when :gentoo
          for_gentoo
        when :archlinux
          for_arch
        else
          Msg.report 'Your distro is not yet supported.'
        end
      end

      protected

      def for_gentoo
        Iptables::Rules.new.save
        case Nomansland.init?
        when :systemd
          systemd_enable('iptables-restore', 'tor')
        when :openrc
          rc_upd = Helpers::Exec.new('rc-update')
          rc_upd.run('rc-update add iptables boot')
          rc_upd.run('rc-update add tor')
          rc_upd.run('rc-update add tor default')
        else
          Msg.report 'Init no yet supported for start Iptables at boot'
        end
      end

      def for_arch
        Iptables::Rules.new.save
        Tor::Config.new(Tempfile.new('torrc')).backup
        systemd_enable('iptables', 'tor')
        Msg.p 'Services enabled for Archlinux...'
      end

      private

      def systemd_enable(*services)
        systemctl = Helpers::Exec.new('systemctl')
        services.each do |s|
          Msg.p "Search for service #{s}..."
          systemctl.run("enable #{s}") unless system("systemctl is-enabled #{s}")
        end
      end

      def systemd_start(service)
        systemctl = Helpers::Exec.new('systemctl')
        Msg.p "Search for service #{service}..."
        systemctl.run("start #{service}") unless system("systemctl is-active #{service}")
      end
    end
  end
end
