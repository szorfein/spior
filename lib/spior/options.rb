require 'optparse'
require_relative 'status'

module Spior
  class Options
    attr_reader :install , :copy, :mac , :interface , :tor

    def initialize(argv)
      @install = false
      @copy = false
      @mac = false
      @tor = false
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

        opts.on("-c", "--card NAME", "The name of the target network card") do |net|
          @interface = net
        end

        opts.on("-m", "--mac", "Change your mac") do
          @mac = true
        end

        opts.on("-t", "--tor", "Redirect traffic through TOR") do
          @tor = true
        end

        opts.on("-s", "--status", "Look infos about your current ip") do
          Spior::Status::info
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
