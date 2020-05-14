require 'nomansland'
require 'tty-which'
require_relative 'copy'
require_relative 'msg'
require_relative 'helpers'

module Spior
  module Persist
    extend self

    def all(card_name)
      @card_name = card_name
      @services=[ "tor", "iptables" ]
      search_for_systemd
    end

    private

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
      iptables_systemd
    end

    def iptables_systemd
      case Nomansland::installer?
      when :pacman
        @iptables_save.run("-f /etc/iptables/iptables.rules")
      when :emerge
        @systemctl.run("start iptables-store")
      when :apt_get
        @iptables_save.run("> /etc/iptables/rules.v4")
      else
        Msg.report "Fail for save iptables-rule, your system is not yet supported"
      end
    end
  end
end
