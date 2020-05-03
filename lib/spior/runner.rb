require_relative 'options'
require_relative 'install'
require_relative 'copy'
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
        Spior::Copy::config_files
      end
    end
  end
end
