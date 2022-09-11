# frozen_string_literal: true

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
      elsif File.exist? '/etc/init.d/tor'
        Helpers::Exec.new('/etc/init.d/tor').run('restart')
      else
        Msg.report "Don't known yet how to restart Tor for your system."
      end
    end
  end
end
