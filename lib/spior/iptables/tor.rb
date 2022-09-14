# frozen_string_literal: true

module Spior
  module Iptables
    # Make Local Redirection Through Tor.
    class Tor < Iptables::Root
      def initialize
        super
        @non_tor = %W[#{@lo_addr}/8 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8]
        @tables  = %w[nat filter]
      end

      private

      def redirect
        @tables.map do |table|
          target = 'ACCEPT'
          target = 'RETURN' if table == 'nat'

          ipt "-t #{table} -F OUTPUT"
          ipt "-t #{table} -A OUTPUT -m state --state ESTABLISHED -j #{target}"
          ipt "-t #{table} -A OUTPUT -m owner --uid #{CONFIG.uid} -j #{target}"

          match_dns_port = CONFIG.dns_port
          if table == 'nat'
            target = "REDIRECT --to-ports #{CONFIG.dns_port}"
            match_dns_port = '53'
          end

          ipt "-t #{table} -A OUTPUT -p udp --dport #{match_dns_port} -j #{target}"
          ipt "-t #{table} -A OUTPUT -p tcp --dport #{match_dns_port} -j #{target}"

          target = "REDIRECT --to-ports #{CONFIG.trans_port}" if table == 'nat'
          ipt "-t #{table} -A OUTPUT -d #{CONFIG.virt_addr} -p tcp -j #{target}"

          target = 'RETURN' if table == 'nat'
          @non_tor.each { |ip|
            ipt "-t #{table} -A OUTPUT -d #{ip} -j #{target}"
          }

          target = "REDIRECT --to-ports #{CONFIG.trans_port}" if table == 'nat'
          ipt "-t #{table} -A OUTPUT -p tcp -j #{target}"
        end
      end

      def input
        # SSH
        ipt '-A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT'
        # Allow loopback
        ipt "-A INPUT -i #{@lo} -j ACCEPT"
        # Accept related
        ipt '-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT'
      end

      def all
        ipt '-t filter -A OUTPUT -p udp -j REJECT'
        ipt '-t filter -A OUTPUT -p icmp -j REJECT'
      end
    end
  end
end
