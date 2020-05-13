require 'tty-which'
require_relative 'msg'
require_relative 'helpers'

module Spior
  module Reload
    def self.tor
      if TTY::Which.exist?('systemctl')
        Helpers::Exec.new("systemctl").run("restart tor")
        Msg.p "ip changed"
      end
    end
  end
end
