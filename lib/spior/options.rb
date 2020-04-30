require 'optparse'

module Spior
  class Options
    attr_reader :install
    attr_reader :copy

    def initialize(argv)
      @install = false
      @copy = false
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|

        opts.on("-i", "--install", "Install dependencies") do
          @install = true
        end

        opts.on("-c", "--copy", "Copy config files") do
          @copy = true
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
