require 'open-uri'
require 'json'

module Spior
  module Status
    def self.enable
      status = "Disable"
      api_check = "https://check.torproject.org/api/ip"
      URI.open(api_check) do |l|
        hash = JSON.parse l.read
        status = "Enable" if hash["IsTor"] == true
      end
      status
    end

    def self.info
      api_check = "https://ipleak.net/json"
      URI.open(api_check) do |l|
        hash = JSON.parse l.read
        puts
        puts "Current ip  ===>  #{hash["ip"]}"
        puts "Continent   ===>  #{hash["continent_name"]}"
        puts "Timezone    ===>  #{hash["time_zone"]}"
      end
      puts "Status      ===>  #{enable}"
    end
  end
end
