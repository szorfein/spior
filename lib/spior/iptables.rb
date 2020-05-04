require 'interfacez'
require_relative 'msg'

module Spior
  class Iptables

    def self.tor(interface = false)
      initialize(interface)
      select_cmd
      flush_rules
      bogus_tcp_flags
      bad_packets
      spoofing
      icmp
      dns
      nat
      input
      output
      forward
    end

    private

    def self.initialize(interface)
      @lo = Interfacez.loopback
      @lo_addr = Interfacez.ipv4_address_of(@lo)
      @tor_dns = 9061
      @trans_port = 9040
      @tor_uid = `id -u tor 2>&1 | grep "^[0-9]*"`.chomp
      @virt_addr= "10.192.0.0/10"
      @non_tor = ["#{@lo_addr}/8", "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      @input = interface
      @input_addr = Interfacez.ipv4_address_of(@input)
    end

    def self.select_cmd
      id=`id -u`
      if id == 0 then
        @i = "iptables"
      else
        @i = "sudo iptables"
      end
    end

    def self.ipt(line)
      system("#{@i} #{line}") 
    end

    def self.flush_rules
      puts "flush"
      ipt "-F"
      ipt "-X"
      ipt "-t nat -F"
      ipt "-t nat -X"
      ipt "-t mangle -F"
      ipt "-t mangle -X"
      ipt "-P INPUT DROP"
      ipt "-P FORWARD DROP"
      ipt "-P OUTPUT DROP"
    end

    def self.bogus_tcp_flags
      puts "bogus"
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

    def self.bad_packets
      puts "bad_packets"
      # new packet not syn
      ipt "-t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP"
      # fragment  packet
      ipt "-A INPUT -f -j DROP"
      # XMAS
      ipt "-A INPUT -p tcp --tcp-flags ALL ALL -j DROP"
      # null packet
      ipt "-A INPUT -p tcp --tcp-flags ALL NONE -j DROP"
    end

    def self.spoofing
      subs=["224.0.0.0/3", "169.254.0.0/16", "172.16.0.0/12", "192.0.2.0/24", "0.0.0.0/8", "240.0.0.0/5"]
      subs.each do |sub|
        ipt "-t mangle -A PREROUTING -s #{sub} -j DROP"
      end
      ipt "-t mangle -A PREROUTING -s #{@lo_addr}/8 ! -i #{@lo} -j DROP"
    end

    def self.icmp
      puts "icmp"
      ipt "-N port-scanning"
      ipt "-A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN"
      ipt "-A port-scanning -j DROP"

      ipt "-N syn_flood"
      ipt "-A INPUT -p tcp --syn -j syn_flood"
      ipt "-A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN"
      ipt "-A syn_flood -j DROP"

      ipt "-A INPUT -p icmp -m limit --limit  1/s --limit-burst 1 -j ACCEPT"
      ipt "-A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:"
      ipt "-A INPUT -p icmp -j DROP"
    end

    def self.dns
      puts "dns"
      ipt "-t nat -A PREROUTING ! -i #{@lo} -p udp -m udp --dport 53 -j REDIRECT --to-ports #{@tor_dns}"
      ipt "-t nat -A OUTPUT -p udp -m udp --dport 53 -j REDIRECT --to-ports #{@tor_dns}"
      ipt "-t nat -A OUTPUT -p tcp -m tcp --dport 53 -j REDIRECT --to-ports #{@tor_dns}"
    end

    def self.nat
      puts "nat"
      # nat .onion addresses
      ipt "-t nat -A OUTPUT -d #{@virt_addr} -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports #{@trans_port}"
              
      # Don't nat the Tor process, the loopback, or the local network
      ipt "-t nat -A OUTPUT -m owner --uid-owner #{@tor_uid} -j RETURN"
      ipt "-t nat -A OUTPUT -o #{@lo} -j RETURN"
              
      # Allow lan access for hosts in $non_tor
      @non_tor.each do |lan|
        ipt "-t nat -A OUTPUT -d #{lan} -j RETURN"
      end

      # Redirects all other pre-routing and output to Tor's TransPort
      ipt "-t nat -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports #{@trans_port}"

      # Redirects all other pre-routing and output to Tor's TransPort
      ipt "-t nat -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports #{@trans_port}"
              
      # input
      ipt "-A INPUT -m state --state ESTABLISHED -j ACCEPT"
      ipt "-A INPUT -i #{@lo} -j ACCEPT"
      
      # output
      ipt "-A OUTPUT -m owner --uid-owner #{@tor_uid} -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j ACCEPT"

      # Allow loopback output
      ipt "-A OUTPUT -d #{@lo_addr}/32 -o #{@lo} -j ACCEPT"
              
      # tor transparent magic
      ipt "-A OUTPUT -d #{@lo_addr}/32 -p tcp -m tcp --dport #{@trans_port} --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT"

      ipt "-t filter -A OUTPUT -p udp -j REJECT"
      ipt "-t filter -A OUTPUT -p icmp -j REJECT"
    end

    def self.input
      puts "input"
      ipt "-A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix \"DROP INVALID \" --log-ip-options --log-tcp-options"
      ipt "-A INPUT -m conntrack --ctstate INVALID -j DROP"
      ipt "-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"
      ipt "-A INPUT -i #{@input} ! -s #{@input_addr} -j LOG --log-prefix \"SPOOFED PKT \""
      ipt "-A INPUT -i #{@input} ! -s #{@input_addr} -j DROP"
      # ACCEPT rules
      ipt "-A INPUT -i #{@input} -p tcp -s #{@input_addr} --dport 22 -m conntrack --ctstate NEW -j ACCEPT"
      
      ipt "-A INPUT ! -i #{@lo} -j LOG --log-prefix \"DROP \" --log-ip-options --log-tcp-options"
      ipt "-A INPUT -i #{@lo} -j ACCEPT"
    end

    def self.output
      puts "output"
      ipt "-A OUTPUT -m conntrack --ctstate INVALID -j LOG --log-prefix \"DROP INVALID \" --log-ip-options --log-tcp-options"
      ipt "-A OUTPUT -m conntrack --ctstate INVALID -j DROP"
      ipt "-A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"

      # ACCEPT rules
      ipt "-A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT"
      ipt "-A OUTPUT ! -o #{@lo} -j LOG --log-prefix \"DROP \" --log-ip-options --log-tcp-options"
      ipt "-A OUTPUT -o #{@lo} -j ACCEPT"
    end

    def self.forward
      puts "forward"
      ipt "-A FORWARD -m conntrack --ctstate INVALID -j LOG --log-prefix \"DROP INVALID \" --log-ip-options --log-tcp-options"
      ipt "-A FORWARD -m conntrack --ctstate INVALID -j DROP"
      ipt "-A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"
      ipt "-A FORWARD -i #{@input} ! -s #{@input_addr} -j LOG --log-prefix \"SPOOFED PKT \""
      ipt "-A FORWARD -i #{@input} ! -s #{@input_addr} -j DROP"
    end
  end
end
