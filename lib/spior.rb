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
