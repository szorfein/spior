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
        when :void
          for_void
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
        Ipv6.new.block_persist
      end

      def for_arch
        Iptables::Rules.new.save
        Tor::Config.new(Tempfile.new('torrc')).backup
        systemd_enable('iptables', 'tor')
        Ipv6.new.block_persist
        Msg.p 'Persist enabled for Arch...'
      end

      def for_void
        Iptables::Rules.new.save
        Tor::Config.new(Tempfile.new('torrc')).backup
        runit_enable('iptables', 'tor')
        Ipv6.new.block_persist
        Msg.p 'Persist enabled for Void...'
      end

      private

      def systemd_enable(*services)
        systemctl = Helpers::Exec.new('systemctl')
        services.each do |s|
          next if system("systemctl is-enabled #{s} >/dev/null")

          systemctl.run("enable #{s}")
          Msg.p "Enabling #{s}..."
        end
      end

      def runit_enable(*services)
        services.each do |s|
          next if File.exist? "/var/service/#{s}"

          Helpers::Exec.new('ln').run("-s /etc/sv/#{s} /var/service/#{s}")
          Msg.p "Enabling #{s}"
        end
      end

      def systemd_start(service)
        systemctl = Helpers::Exec.new('systemctl')
        return if system("systemctl is-active #{service} >/dev/null")

        Msg.p "Search for service #{service}..."
        systemctl.run("start #{service}")
      end
    end
  end
end
