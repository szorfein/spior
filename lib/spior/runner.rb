require_relative 'options'
require_relative 'install'
require_relative 'msg'

module Spior
  class Runner
    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
      if @options.install then
        Msg.head
        Spior::Install::dependencies
      end
      if @options.copy then
        Msg.head
        Spior::Install::config_files
      end
    end
  end
end
