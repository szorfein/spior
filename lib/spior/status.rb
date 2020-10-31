require 'open-uri'
require 'json'

module Spior
  module Status
    def self.enable
      begin
        status = "Disable"
        api_check = "https://check.torproject.org/api/ip"
        URI.open(api_check) do |l|
          hash = JSON.parse l.read
          status = "Enable" if hash["IsTor"] == true
        end
        status
      rescue OpenURI::HTTPError => error
        res = error.io
        puts "Fail to join server #{res.status}"
      end
    end

    def self.info
      begin
        api_check = "https://ipleak.net/json"
        URI.open(api_check) do |l|
          hash = JSON.parse l.read
          puts
          puts " Current ip  ===>  #{hash["ip"]}"
          puts " Continent   ===>  #{hash["continent_name"]}"
          puts " Timezone    ===>  #{hash["time_zone"]}"
        end
        puts " Status      ===>  #{enable}"
      rescue OpenURI::HTTPError => error
        res = error.io
        puts "Fail to join server #{res.status}"
      end
    end
  end
end
