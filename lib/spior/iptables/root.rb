require 'interfacez'

module Spior
  module Iptables
    class Root
      def initialize
        @lo      = Interfacez.loopback
        @lo_addr = Interfacez.ipv4_address_of(@lo)
        @i = Helpers::Exec.new("iptables")
        Spior::Copy.new.save
      end

      def run!
        stop!
        bogus_tcp_flags
        bad_packets
        spoofing
        redirect
        input
        output
        all
      end

      def stop!
        ipt "-F"
        ipt "-X"
        ipt "-t nat -F"
        ipt "-t nat -X"
        ipt "-t mangle -F"
        ipt "-t mangle -X"
      end

      private

      def ipt(line)
        @i.run("#{line}")
        puts "added - #{@i} #{line}"
      end

      def redirect
      end

      def input
      end

      def output
      end

      def all
      end

      def bogus_tcp_flags
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP"
        ipt "-t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP"
      end

      def bad_packets
        # new packet not syn
        ipt "-t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP"
        # fragment  packet
        ipt "-A INPUT -f -j DROP"
        # XMAS
        ipt "-A INPUT -p tcp --tcp-flags ALL ALL -j DROP"
        # null packet
        ipt "-A INPUT -p tcp --tcp-flags ALL NONE -j DROP"
      end

      def spoofing
        subs=["224.0.0.0/3", "169.254.0.0/16", "172.16.0.0/12", "192.0.2.0/24", "0.0.0.0/8", "240.0.0.0/5"]
        subs.each do |sub|
          ipt "-t mangle -A PREROUTING -s #{sub} -j DROP"
        end
        ipt "-t mangle -A PREROUTING -s #{@lo_addr}/8 ! -i #{@lo} -j DROP"
      end
    end
  end
end
