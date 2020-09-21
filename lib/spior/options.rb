require 'optparse'

module Spior
  class Options
    attr_reader :install , :mac , :interface , :tor , :persist

    def initialize(argv)
      @install = false
      @mac = false
      @tor = false
      @persist = false
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.on("-i", "--install", "Check and install dependencies") do
          @install = true
        end

        opts.on("-n", "--net-card NAME", "The name of the target network card") do |net|
          @interface = net
        end

        opts.on("-t", "--tor", "Redirect traffic through TOR") do
          @tor = true
        end

        opts.on("-r", "--reload", "Reload TOR to change your ip") do
          Spior::Reload::tor
        end

        opts.on("-c", "--clear", "Clear iptables rules and restore files") do
          Spior::Clear::all
        end

        opts.on("-s", "--status", "Look infos about your current ip") do
          Spior::Status::info
        end

        opts.on("-p", "--persist", "Active Spior at every boot.") do
          @persist = true
        end

        opts.on("-m", "--menu", "Display an interactive menu") do
          Spior::Menu::run
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          argv = ["-m"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
