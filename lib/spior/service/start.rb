require 'tty-which'

module Spior
  module Service
    module_function

    def start
      if TTY::Which.exist?('systemctl')
        state = `systemctl is-active tor`.chomp
        unless state == 'active'
          Helpers::Exec.new("systemctl").run("start tor")
          Msg.p "TOR started."
        end
      elsif TTY::Which.exist? 'sv'
        unless File.exist? '/var/service/tor'
          Helpers::Exec.new('ln').run('-s /etc/sv/tor /var/service/tor')
          Msg.p "TOR started."
        end
      else
        Msg.report "Don't known yet how to start TOR for your system."
      end
    end
  end
end
