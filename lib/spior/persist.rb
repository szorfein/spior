require 'nomansland'
require 'tty-which'

module Spior
  module Persist
    extend self

    def enable
      case Nomansland::distro?
      when :gentoo
        for_gentoo
      else
        Msg.p "Your distro is not yet supported."
      end
    end

    private

    def for_gentoo
      if TTY::Which.exist?('systemctl')
        systemd_start("iptables-store")
        systemd_enable("iptables-restore")
        systemd_enable("tor")
      else
        system("sudo /etc/init.d/iptables save")
        rc_upd = Helpers::Exec.new("rc-update")
        rc_upd.run("rc-update add iptables boot")
        rc_upd.run("rc-update add tor")
        rc_upd.run("rc-update add tor default")
      end
    end

    def systemd_enable(service)
      systemctl = Helpers::Exec.new("systemctl")
      Msg.p "Search for service #{service}..."
      `systemctl is-enabled #{service}`
      if not $?.success? then
        systemctl.run("enable #{service}")
      end
    end

    def systemd_start(service)
      systemctl = Helpers::Exec.new("systemctl")
      Msg.p "Search for service #{service}..."
      `systemctl is-active #{service}`
      if not $?.success? then
        systemctl.run("start #{service}")
      end
    end
  end
end
