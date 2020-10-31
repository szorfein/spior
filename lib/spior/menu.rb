module Spior
  module Menu
    extend self

    def run
      banner
      loop do
        Msg.head
        puts %q{Please select an option:

  1. Redirect traffic through tor
  2. Reload tor and change your ip
  3. Clear and restore your files
  4. Check info on your current ip
  5. Quit}

        puts
        print ">> "
        case gets.chomp
        when '1'
          check_network
          Spior::Iptables::tor(@network.card)
        when '2'
          Spior::Tor.restart
        when '3'
          Spior::Clear::all
        when '4'
          Spior::Status::info
        when '5'
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
