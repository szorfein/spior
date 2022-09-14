# frozen_string_literal: true

require 'nomansland'

module Spior
  module Tor
    ##
    # Data
    # Fill Spior::CONFIG with data on Tor found on /etc/tor/torrc or use default
    class Data
      attr_accessor :user, :dns_port, :dns_listen_address
      attr_accessor :trans_port, :virt_addr, :uid

      def initialize
        @user = search('User') || 'tor'
        @dns_port = search('DNSPort') || '9061'
        @dns_listen_address = search('DNSListenAddress') || '127.0.0.1'
        @trans_port = search('TransPort') || '9040'
        @virt_addr = search('VirtualAddrNetworkIPv4') || '10.192.0.0/10'
        @uid = search_uid || 0
      end

      private
      
      # Search value of option_name in the /etc/tor/torrc
      # Return false by default
      def search(option_name)
        File.open('/etc/tor/torrc') do |f|
          f.each do |line|
            return Regexp.last_match(1) if line.match(/#{option_name} ([a-z0-9]*)/i)
          end
        end
        false
      end

      def search_uid
        case Nomansland.distro?
        when :debian || :ubuntu
          `id -u debian-tor`.chomp
        else
          `id -u #{@user}`.chomp
        end
      end
    end
  end
end
