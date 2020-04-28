require_relative 'options'

module Spior
  class Runner
    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
    end
  end
end
