# frozen_string_literal: true

module Spior
  module Iptables
    # Default and generic Iptables rules when Tor is not used.
    #
    # Allowed ports:
    # * Input 22: for ssh connection
    class Default < Iptables::Root

      private

      def input
        # SSH
        ipt '-A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT'
        # Allow loopback, rules
        ipt "-A INPUT -i #{@lo} -j ACCEPT"
        # Accept related
        ipt '-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT'
      end

      def output
        ipt '-A OUTPUT -m conntrack --ctstate INVALID -j DROP'
        ipt '-A OUTPUT -m state --state ESTABLISHED -j ACCEPT'

        # Allow SSH
        ipt '-A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT'

        # Allow Loopback
        ipt "-A OUTPUT -d #{@lo_addr}/8 -o #{@lo} -j ACCEPT"

        # Default
        ipt '-A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT'
      end

      def all
        ipt '-t filter -A OUTPUT -p udp -j ACCEPT'
        ipt '-t filter -A OUTPUT -p icmp -j REJECT'
        ipt '-P INPUT ACCEPT'
        ipt '-P FORWARD ACCEPT'
        ipt '-P OUTPUT ACCEPT'
      end
    end
  end
end
