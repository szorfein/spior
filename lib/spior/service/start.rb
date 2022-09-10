module Spior
  module Service
    module_function

    def start
      Dep.check
      Tor.start
      Iptables::Tor.new.run!
    end
  end
end
