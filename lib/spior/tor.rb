require 'pathname'
require 'nomansland'
require_relative 'msg'

module Spior
  class Tor
    attr_accessor :dns, :uid, :trans_port, :virt_addr

    def initialize
      @dns = search_dns
      @uid = search_uid
      @trans_port = search_trans_port
      @virt_addr = search_virt_addr
    end

    private 

    def search_dns
      9061
    end

    def search_uid
      case Nomansland::distro?
        when :debian
          `id -u debian-tor`.chomp
        when :ubuntu
          `id -u debian-tor`.chomp
        else
          `id -u tor`.chomp
      end
    end

    def search_trans_port
      9040
    end

    def search_virt_addr
      "10.192.0.0/10"
    end
  end
end
