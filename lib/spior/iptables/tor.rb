module Spior
  module Iptables
    class Tor < Iptables::Root
      def initialize
        super
        @tor     = Spior::Tor::Info.new
        @non_tor = ["#{@lo_addr}/8", "192.168.0.0/16", "172.16.0.0/12", "10.0.0.0/8"]
        @tables  = ["nat", "filter"]
      end

      private

      def redirect
        @tables.each { |table|
          target = "ACCEPT"
          target = "RETURN" if table == "nat"

          ipt "-t #{table} -F OUTPUT"
          ipt "-t #{table} -A OUTPUT -m state --state ESTABLISHED -j #{target}"
          ipt "-t #{table} -A OUTPUT -m owner --uid #{@tor.uid} -j #{target}"

          match_dns_port = @tor.dns
          if table == "nat"
            target = "REDIRECT --to-ports #{@tor.dns}"
            match_dns_port = "53"
          end

          ipt "-t #{table} -A OUTPUT -p udp --dport #{match_dns_port} -j #{target}"
          ipt "-t #{table} -A OUTPUT -p tcp --dport #{match_dns_port} -j #{target}"

          target = "REDIRECT --to-ports #{@tor.trans_port}" if table == "nat"
          ipt "-t #{table} -A OUTPUT -d #{@tor.virt_addr} -p tcp -j #{target}"

          target = "RETURN" if table == "nat"
          @non_tor.each { |ip|
            ipt "-t #{table} -A OUTPUT -d #{ip} -j #{target}"
          }

          target = "REDIRECT --to-ports #{@tor.trans_port}" if table == "nat"
          ipt "-t #{table} -A OUTPUT -p tcp -j #{target}"
        }
      end

      def input
        # SSH
        ipt "-A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT"
        # Allow loopback
        ipt "-A INPUT -i #{@lo} -j ACCEPT"
        # Accept related
        ipt "-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"
      end

      def all
        ipt "-t filter -A OUTPUT -p udp -j REJECT"
        ipt "-t filter -A OUTPUT -p icmp -j REJECT"
        ipt "-P INPUT DROP"
        ipt "-P FORWARD DROP"
        ipt "-P OUTPUT DROP"
      end
    end
  end
end
