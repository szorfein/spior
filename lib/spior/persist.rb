require 'nomansland'
require 'tty-which'
require_relative 'copy'
require_relative 'msg'

module Spior
  module Persist
    extend self

    def all(card_name)
      @card_name = card_name
      search_for_systemd
    end

    private

    def search_for_systemd
      return if !TTY::Which.exist?('systemctl') 
      Spior::Copy::systemd_services
      services=[ "tor", "iptables", "deceitmac@" + @card_name ]
      services.each do |service|
        Msg.p "Search for service #{service}..."
        system("if ! systemctl is-enabled #{service} ; then sudo systemctl enable #{service} ; fi")
      end
      iptables_systemd
    end

    def iptables_systemd
      case Nomansland::installer?
      when :pacman
        system('sudo iptables-save -f /etc/iptables/iptables.rules')
      when :emerge
        system('sudo systemctl start iptables-store')
      else
        Msg.report "Fail for save iptables-rule, your system is not yet supported"
      end
    end
  end
end
