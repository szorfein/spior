require 'nomansland'
require 'tty-which'
require_relative 'copy'
require_relative 'msg'
require_relative 'helpers'

module Spior
  module Persist
    extend self

    def all
      @services=[ "tor", "iptables" ]
      services
      save_rules
      search_for_systemd
    end

    private

    # Install a systemd service where needed. TODO: test on more distrib
    # no need on: archlinux
    # need on: gentoo, debian, 
    def services
      return if !TTY::Which.exist?('systemctl') 
      path_bin = "/sbin/iptables-restore"
      path_rules = ""
      case Nomansland::distro?
      when :gentoo
        path_rules = "/var/lib/iptables/rules-save"
      when :debian
        path_rules = "/etc/iptables/rules.v4"
      end
      string = <<EOF
[Unit]
Description=IPv4 Packet Filtering Framework for Spior
Before=network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
ExecStart=#{path_bin} #{path_rules}
ExecReload=#{path_bin} #{path_rules}
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
      case Nomansland::distro?
      when :gentoo
        new_systemd = Helpers::NewSystemd.new(string, "iptables.services")
        new_systemd.add
        new_systemd.perm("root", "644")
      end
    end

    def search_for_systemd
      return if !TTY::Which.exist?('systemctl') 
      @systemctl = Helpers::Exec.new("systemctl")
      @iptables_save = Helpers::Exec.new("iptables-save")
      Spior::Copy::systemd_services
      @services.each do |service|
        Msg.p "Search for service #{service}..."
        `systemctl is-enabled #{service}`
        if not $?.success? then
          @systemctl.run("enable #{service}")
        end
      end
    end

    def save_rules
      case Nomansland::installer?
      when :pacman
        @iptables_save.run("-f /etc/iptables/iptables.rules")
      when :emerge
        @systemctl = Helpers::Exec.new("systemctl")
        @systemctl.run("start iptables-store")
      when :apt_get
        @iptables_save.run("> /etc/iptables/rules.v4")
      else
        Msg.report "Fail for save iptables-rule, your system is not yet supported"
      end
    end
  end
end
