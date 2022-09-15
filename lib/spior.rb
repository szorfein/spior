require_relative 'spior/clear'
require_relative 'spior/copy'
require_relative 'spior/dep'
require_relative 'spior/iptables'
require_relative 'spior/msg'
require_relative 'spior/options'
require_relative 'spior/status'
require_relative 'spior/tor'
require_relative 'spior/persist'
require_relative 'spior/menu'
require_relative 'spior/service'
require_relative 'spior/helpers'

module Spior
  # Contain value of Tor::Data
  # Can be customized, e.g:
  #
  #   Spior::CONFIG.dns_port = '5353'
  #   Spior::CONFIG.trans_port = '8888'
  #   Spior::CONFIG.uid = '666'
  #   Spior::CONFIG.user = 'Tor-User-System'
  #   Spior::CONFIG.virt_addr = '10.192.0.0/10'
  CONFIG = Tor::Data.new

  class Main
    def initialize(argv)
      @argv = argv
      run
    end

    private

    def run
      options = Options.new(@argv)

      if options.install
        Msg.head
        Dep.install
        Copy.new.save
      end

      if options.persist
        Persist.enable
      end
    end
  end
end
