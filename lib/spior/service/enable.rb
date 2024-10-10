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
        when :debian
          for_debian
        else
          Msg.report 'Your distro is not yet supported.'
        end
      end

      protected

      def for_gentoo
        case Nomansland.init?
        when :systemd
          Iptables::Rules.new.save
          systemd_enable('iptables-restore', 'tor')
        when :openrc
          Helpers.cmd('rc-service iptables save')
          Helpers.cmd('rc-update add iptables boot') # default or boot ?
          Helpers.cmd('rc-update add tor default')
        else
          Msg.report 'Init no yet supported for start Iptables at boot'
        end
        Ipv6.new.block_persist
        Msg.p 'Persist enabled for Gentoo...'
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

      # https://wiki.debian.org/iptables
      def for_debian
        Iptables::Rules.new.save
        Tor::Config.new(Tempfile.new('torrc')).backup
        systemd_enable('tor')
        File.write('/tmp/start_iptables',
                   "#!/bin/sh\n/sbin/iptables-restore < /etc/iptables.up.rules\n")
        Helpers.mv('/tmp/start_iptables', '/etc/network/if-pre-up.d/iptables')
        Helpers.cmd('chmod +x /etc/network/if-pre-up.d/iptables')
        Ipv6.new.block_persist
        Msg.p 'Persist mode enabled for Debian...'
      end

      private

      def systemd_enable(*services)
        services.each do |s|
          next if system("systemctl is-enabled #{s} >/dev/null")

          Helpers.cmd("systemctl enable #{s}")
          Msg.p "Enabling #{s}..."
        end
      end

      def runit_enable(*services)
        services.each do |s|
          next if File.exist? "/var/service/#{s}"

          Helpers.cmd("ln -s /etc/sv/#{s} /var/service/#{s}")
          Msg.p "Enabling #{s}"
        end
      end

      def systemd_start(service)
        return if system("systemctl is-active #{service} >/dev/null")

        Msg.p "Search for service #{service}..."
        Helpers.cmd("systemctl start #{service}")
      end
    end
  end
end
