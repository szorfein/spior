require_relative 'options'
require_relative 'install'

module Spior
  class Runner
    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
      if @options.install then
        Spior::Install::dependencies
      end
    end
  end
end
