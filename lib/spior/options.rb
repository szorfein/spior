# frozen_string_literal: true

require 'optparse'

module Spior
  # Options for the CLI
  class Options
    def initialize(argv)
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.on('-i', '--install', 'Install the dependencies.') do
          Dep.looking
        end

        opts.on('-t', '--tor', 'Redirect traffic through TOR.') do
          Service.start
        end

        opts.on('-r', '--reload', 'Reload TOR to change your IP.') do
          Service.restart
          exit
        end

        opts.on('-c', '--clearnet', 'Reset iptables and return to clearnet navigation.') do
          Service.stop
        end

        opts.on('-s', '--status', 'Look infos about your current IP.') do
          Status.info
          exit
        end

        opts.on('-p', '--persist', 'Active Spior at every boot.') do
          Service::Enable.new
        end

        opts.on('-m', '--menu', 'Display an interactive menu.') do
          Menu.run
        end

        opts.on('-h', '--help', 'Show this message.') do
          puts opts
          exit
        end

        begin
          argv = ['-m'] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          warn e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
