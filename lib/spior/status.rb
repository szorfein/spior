require 'open-uri'

module Spior
  module Status

    # TODO: if someone want help, i have trouble to use JSON.parse()
    def self.info
      puts
      uri = URI.parse("https://ipleak.net/json")
      uri.open { |f|
        f.each_line { |line|
          line_filter = line.chomp.delete("/\",{}").gsub(/\s*/, "")
          puts "  =>  #{line_filter}" if line.match(/country/)
          puts "  =>  #{line_filter}" if line.match(/continent/)
          puts "  =>  #{line_filter}" if line.match(/time_zone/)
          puts "  =>  #{line_filter}" if line.match(/ip/)
        }
      }
      puts
    end
  end
end
