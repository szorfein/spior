module Spior
  module Service
    module_function

    def start
      case init?
      when :systemd
        Msg.p "Detect a Systemd system, starting Tor..."
        state = `systemctl is-active tor`.chomp
        unless state == 'active'
          Helpers::Exec.new("systemctl").run("start tor")
          Msg.p "TOR started."
        end
      when :runit
        Msg.p "Detect a Runit system, starting Tor..."
        unless File.exist? '/var/service/tor'
          Helpers::Exec.new('ln').run('-s /etc/sv/tor /var/service/tor')
          Msg.p "TOR started."
        end
      when :openrc
        Msg.p "Detect an Openrc system, starting Tor..."
        Helpers::Exec.new('/etc/init.d/tor').run('start')
      else
        Msg.report "Don't known yet how to start Tor for your system."
      end
    end

    def init?
      return :systemd if Dir.exist? '/etc/systemd'
      return :runit if Dir.exist? '/etc/runit'
      return :openrc if Dir.exist? '/etc/init.d'
    end
  end
end
