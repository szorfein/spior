#!/usr/bin/env ruby

require 'open-uri'

module Spior
  class Status

    # TODO: if someone want help, i have trouble to make JSON.parse() work here
    # the output is very very ugly !
    def self.info
      uri = URI.parse("https://ipleak.net/json")
      uri.open {|f|
        f.each_line {|line|
          p line.chomp.delete("/\",{}")
        }
      }
    end

  end
end
