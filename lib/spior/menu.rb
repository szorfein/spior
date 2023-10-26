# frozen_string_literal: true

module Spior
  # Build an interactive menu for spior
  module Menu
    def self.run
      loop do
        Msg.head
        puts 'Please select an option:

  1. Redirect traffic through Tor
  2. Reload Spior and change your IP
  3. Stop Tor and use a clearnet navigation
  4. Check info on your current IP
  5. Install all the dependencies
  6. Quit'

        puts
        print '>> '
        case gets.chomp
        when '1'
          Service.start
        when '2'
          Service.restart
        when '3'
          Service.stop
        when '4'
          Status.info
        when '5'
          Dep.looking
        else
          exit
        end
      end
    end
  end
end
