require 'tty-which'
require_relative 'msg'

module Spior
  module Reload
    def self.tor
      if TTY::Which.exist?('systemctl')
        system('sudo systemctl restart tor')
        Msg.p "ip changed"
      end
    end
  end
end
