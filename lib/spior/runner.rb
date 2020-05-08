require_relative 'options'
require_relative 'install'
require_relative 'copy'
require_relative 'mac'
require_relative 'iptables'
require_relative 'network'
require_relative 'persist'
require_relative 'msg'

module Spior
  class Runner
    def initialize(argv)
      @options = Options.new(argv)
      @network = false
    end

    def run
      if @options.install then
        Msg.head
        Spior::Install::dependencies
        Spior::Copy::config_files
      end
      if @options.mac then
        Msg.head
        Spior::Install::check_mac
        if not @network
          @network = Spior::Network.new(@options.interface)
        end
        Spior::MAC::randomize(@network.card)
      end
      if @options.tor then
        Msg.head
        Spior::Install::check_base
        Spior::Copy::config_files
        if not @network
          @network = Spior::Network.new(@options.interface)
        end
        Spior::Iptables::tor(@network.card)
      end
      if @options.persist then
        if not @network
          @network = Spior::Network.new(@options.interface)
        end
        Spior::Persist::all(@network.card)
      end
    end
  end
end
