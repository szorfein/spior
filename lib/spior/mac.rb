require "pathname"
require "interfacez"
require_relative "msg"

module Spior
  class MAC 

    def self.randomize(interface)
      @network_int = interface
      @check = false
      check_dep
      verify_card 
      if @check == false then
        puts "Checking network interface..."
        ask_for_card
      end
      system("deceitmac --interface #{@network_int} --random --dhcpcd --tor --no-banner")
    end

    private

    def self.check_dep
      if ! Pathname.new("/usr/local/bin/deceitmac") then
        Msg.error "deceitmac is not installed, please, exec spior --install"
        exit(-1)
      end
    end

    def self.verify_card
      return if @check or not @network_int
      Interfacez.all do |interface|
        if interface == @network_int then
          @check = true
        end
      end
      if not @check then
        Msg.err "Your interface #{@network_int} is no found"
      end
    end

    def self.ask_for_card
      until @check == true
        Interfacez.all do |interface|
          print interface + " "
        end
        printf "\nWhich interface to randomize ? "
        @network_int = gets.chomp
        verify_card
      end
    end
  end
end
