# frozen_string_literal: true

require 'open-uri'
require 'json'

module Spior
  module Status
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
