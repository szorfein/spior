module Spior
  module Service
    module_function

    def stop
      case Nomansland.init?
      when :systemd
        Msg.p "Stopping Tor with Systemd..."
        Helpers::Exec.new('systemctl').run('stop tor')
      when :runit
        Msg.p "Stopping Tor with Runit..."
        Helpers::Exec.new('sv').run('stop tor')
      when :openrc
        Msg.p "Stopping Tor with Openrc..."
        Helpers::Exec.new('/etc/init.d/tor').run('stop')
      else
        Msg.report "Don't known how to stop Tor on your system."
      end
    end
  end
end
