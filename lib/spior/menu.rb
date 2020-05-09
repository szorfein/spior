require_relative 'msg'
require_relative 'mac'
require_relative 'iptables'
require_relative 'network'
require_relative 'reload'
require_relative 'clear'
require_relative 'status'

module Spior
  module Menu
    extend self

    def run
      banner
      loop do
        Msg.head
        puts %q{Please select an option:

  1. Forge a new MAC address
  2. Redirect traffic through tor
  3. Reload tor and change your ip
  4. Clear and restore your files
  5. Check info on your current ip
  6. Quit}

        puts
        print ">> "
        case gets.chomp
          when '1'
            check_network
            Spior::MAC::randomize(@network.card)
          when '2'
            check_network
            Spior::Iptables::tor(@network.card)
          when '3'
            Spior::Reload::tor
          when '4'
            Spior::Clear::all
          when '5'
            Spior::Status::info
          when '6'
            exit
        end
      end
    end

    private 

    def banner
      puts "┏━┓┏━┓╻┏━┓┏━┓"
      puts "┗━┓┣━┛┃┃ ┃┣┳┛"
      puts "┗━┛╹  ╹┗━┛╹┗╸"
      # generated with toilet -F crop -f future spior
    end

    def check_network
      if not @network
        @network = Spior::Network.new
      end
    end
  end
end
