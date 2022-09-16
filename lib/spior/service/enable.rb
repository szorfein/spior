# frozen_string_literal: true

require 'nomansland'

module Spior
  module Service
    extend self

    # enable the Tor redirection when you boot your system
    #
    # It should use and enable the services:
    # + tor
    # + iptables
    def enable
      case Nomansland.distro?
      when :gentoo
        for_gentoo
      when :archlinux
        Iptables::Rules.new.backup
        Tor::Config.new(Tempfile.new('torrc')).backup
        Helpers::Exec.new('systemctl').run('enable iptables tor')
        Msg.p 'Services enabled for Archlinux...'
      else
        Msg.report 'Your distro is not yet supported.'
      end
    end

    private

    def for_gentoo
      case Nomansland.init?
      when :systemd
        systemd_start('iptables-store')
        systemd_enable('iptables-restore')
        systemd_enable('tor')
      when :openrc
        system('sudo /etc/init.d/iptables save')
        rc_upd = Helpers::Exec.new('rc-update')
        rc_upd.run('rc-update add iptables boot')
        rc_upd.run('rc-update add tor')
        rc_upd.run('rc-update add tor default')
      else
        Msg.report 'Init no yet supported for start Iptables at boot'
      end
    end

    def systemd_enable(service)
      systemctl = Helpers::Exec.new('systemctl')
      Msg.p "Search for service #{service}..."
      unless system("systemctl is-enabled #{service}")
        systemctl.run("enable #{service}")
      end
    end

    def systemd_start(service)
      systemctl = Helpers::Exec.new('systemctl')
      Msg.p "Search for service #{service}..."
      unless system("systemctl is-active #{service}")
        systemctl.run("start #{service}")
      end
    end
  end
end
