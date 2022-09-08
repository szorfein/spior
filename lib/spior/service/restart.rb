require 'nomansland'

module Spior
  module Service
    module_function

    def restart
      case Nomansland.init?
      when :systemd
        Helpers::Exec.new("systemctl").run("restart tor")
      when :runit
        Helpers::Exec.new('sv').run('restart tor')
      when :openrc
        Helpers::Exec.new('/etc/init.d/tor').run('restart')
      else
        Msg.report "Don't known yet how to restart Tor for your system."
      end

      Msg.p 'ip changed.'
    end
  end
end
