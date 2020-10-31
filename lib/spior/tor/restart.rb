require 'tty-which'

module Spior
  module Tor
    module_function
    def restart
      if TTY::Which.exist?('systemctl')
        Helpers::Exec.new("systemctl").run("restart tor")
        Msg.p "ip changed"
      end
    end
  end
end
