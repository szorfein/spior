require_relative 'spior/clear'
require_relative 'spior/copy'
require_relative 'spior/install'
require_relative 'spior/iptables'
require_relative 'spior/msg'
require_relative 'spior/options'
require_relative 'spior/reload'
require_relative 'spior/status'
require_relative 'spior/tor'
require_relative 'spior/persist'
require_relative 'spior/network'
require_relative 'spior/menu'
require_relative 'spior/helpers'

module Spior
  class Main
    def initialize(argv)
      @argv = argv
      run
    end

    private

    def check_network(network)
      if network
        @network = nil
      else
        @network = Spior::Network.new
      end
    end

    def run
      options = Options.new(@argv)
      check_network(options.interface)

      if options.install
        Msg.head
        Install::check_deps
        Copy::config_files
      end

      if options.tor
        Msg.head
        Iptables.new(@network).run!
      end

      if options.persist
        Persist::all
      end
    end
  end
end
