require 'optparse'

module Spior
  class Options
    attr_reader :install , :persist

    def initialize(argv)
      @install = false
      @persist = false
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.on("-i", "--install", "Install the dependencies") do
          @install = true
        end

        opts.on("-t", "--tor", "Redirect traffic through TOR") do
          Spior::Service.start
        end

        opts.on("-r", "--reload", "Reload TOR to change your ip") do
          Spior::Service.restart
          exit
        end

        opts.on("-c", "--clearnet", "Reset iptables and return to clearnet navigation") do
          Spior::Service.stop
        end

        opts.on("-s", "--status", "Look infos about your current ip") do
          Spior::Status.info
          exit
        end

        opts.on("-p", "--persist", "Active Spior at every boot.") do
          @persist = true
        end

        opts.on("-m", "--menu", "Display an interactive menu") do
          Spior::Menu.run
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
