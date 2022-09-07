module Spior
  module Tor
    class Data
      attr_reader :user, :dns_port, :dns_listen_address, :trans_port, :virt_addr

      def initialize
        @user = search('User') || 'tor'
        @dns_port = search('DNSPort') || '9061'
        @dns_listen_address = search('DNSListenAddress') || '127.0.0.1'
        @trans_port = search('TransPort') || '9040'
        @virt_addr = search('VirtualAddrNetworkIPv4') || '10.192.0.0/10'
      end

      private
      
      # Search value of option_name in the /etc/tor/torrc
      # Return false by default
      def search(option_name)
        File.open("/etc/tor/torrc") do |f|
          f.each do |line|
            return Regexp.last_match(1) if line.match(/#{option_name} ([a-z0-9]*)/i)
          end
        end
        false
      end
    end
  end
end
