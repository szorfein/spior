# frozen_string_literal: true

require 'open-uri'
require 'json'

module Spior

  # Status display information on your current IP addresse
  #
  # If you use an IPV6 address, it should fail to display a Tor IP...
  module Status

    # enable check if Tor is enable or not
    def self.enable
      status = 'Disable'
      URI.open('https://check.torproject.org/api/ip') do |l|
        hash = JSON.parse l.read
        status = 'Enable' if hash['IsTor'] == true
      end
      status
    rescue OpenURI::HTTPError => error
      res = error.io
      puts "Fail to join server #{res.status}"
    end

    # info check https://ipleak.net/json to display information
    #
    # We can add later info on City/Region or other things.
    def self.info
      URI.open('https://ipleak.net/json') do |l|
        hash = JSON.parse l.read
        puts
        puts " Current ip  ===>  #{hash['ip']}"
        puts " Continent   ===>  #{hash['continent_name']}"
        puts " Timezone    ===>  #{hash['time_zone']}"
      end
      puts " Status      ===>  #{enable}"
    rescue OpenURI::HTTPError => error
      res = error.io
      puts "Fail to join server #{res.status}"
    end
  end
end
