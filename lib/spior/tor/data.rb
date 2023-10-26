# frozen_string_literal: true

require 'nomansland'

module Spior
  module Tor
    ##
    # Data
    # Fill Spior::CONFIG with data found on `/etc/tor/torrc` or set default.
    #
    # ==== Attributes
    #
    # * +user+ - Username used by Tor on your distro, e.g 'tor' on Archlinux
    # * +dns_port+ - Open this port to listen for UDP DNS requests, and resolve them anonymously
    # * +uid+ - The uid value from the user attribute.
    # * +trans_port+ - Port to open to listen for transparent proxy connections.
    # * +virt_addr+ - Default use '10.192.0.0/10'.
    #
    class Data
      attr_accessor :user, :dns_port, :trans_port, :virt_addr, :uid

      def initialize
        @user = search('User') || 'tor'
        @dns_port = search('DNSPort') || '9061'
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
            line.match(%r{^#{option_name} ([a-z0-9./]*)}i) and
              return Regexp.last_match(1)
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
