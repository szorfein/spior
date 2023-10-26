# frozen_string_literal: true

require_relative 'spior/dep'
require_relative 'spior/iptables'
require_relative 'spior/msg'
require_relative 'spior/options'
require_relative 'spior/status'
require_relative 'spior/tor'
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

  # Main for the CLI
  class Main
    def initialize(argv)
      @argv = argv
      x
    end

    private

    def x
      Msg.banner
      Options.new(@argv)
    end
  end
end
