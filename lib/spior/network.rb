require 'interfacez'
require_relative 'msg'

module Spior
  class Network
    attr_accessor :card

    def initialize(name = false)
      @name = name
      @check = false
    end

    def card
      verify_card
      if @check == false then
        ask_for_card
      end
      @name
    end

    private

    def verify_card
      return if @check or not @name
      Interfacez.all do |interface|
        if interface == @name then
          @check = true
        end
      end
      if not @check then
        Msg.err "Your interface #{@name} is no found"
      end
    end

    def ask_for_card
      until @check == true
        Interfacez.all do |interface|
          print interface + " "
        end
        printf "\nWhat is the name of the card to be used? "
        @name = gets.chomp
        verify_card
      end
    end
  end
end
