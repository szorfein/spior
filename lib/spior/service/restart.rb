require 'tty-which'

module Spior
  module Service
    module_function

    def restart
      if TTY::Which.exist?('systemctl')
        Helpers::Exec.new("systemctl").run("restart tor")
        Msg.p "ip changed."
      elsif TTY::Which.exist? 'sv'
        Helpers::Exec.new('sv').run('restart tor')
        Msg.p 'ip changed.'
      else
        Msg.report "Dont't known yet how to restart tor for your system."
      end
    end
  end
end
