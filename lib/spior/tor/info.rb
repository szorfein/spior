require 'pathname'
require 'nomansland'

module Spior
  module Tor
    class Info

      def initialize
        @systemctl = Helpers::Exec.new("systemctl")
        @data = Tor::Data.new
      end

      private 

      def check_deps
        Spior::Copy.new.save
        add_torrc
        Spior::Service.start
      end

      def add_torrc
        user = case Nomansland::distro?
               when :debian
                 'debian-tor'
               when :ubuntu
                 'debian-tor'
               else
                 @data.user
               end

        string = <<~TORRC
# Generated by Spior
User #{user}
DNSPort #{@data.dns_listen_address}:#{@data.dns_port}
AutomapHostsOnResolve 1
AutomapHostsSuffixes .exit,.onion
VirtualAddrNetworkIPv4 #{@data.virt_addr}
TransPort #{@data.trans_port} IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort
TestSocks 1
MaxCircuitDirtiness 600
TORRC
        new_file = Helpers::NewFile.new(string, "torrc", "/etc/tor")
        new_file.add
        new_file.perm("root", "644")
      end
    end
  end
end
