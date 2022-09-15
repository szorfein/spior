# frozen_string_literal: true

module Spior
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
          Spior::Service.start
        when '2'
          Spior::Service.restart
        when '3'
          Spior::Service.stop
        when '4'
          Spior::Status.info
        when '5'
          Spior::Dep.looking
        else
          exit
        end
      end
    end
  end
end
