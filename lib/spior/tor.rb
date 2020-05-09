require 'pathname'
require 'nomansland'
require 'tty-which'
require_relative 'msg'
require_relative 'install'
require_relative 'copy'

module Spior
  class Tor
    attr_accessor :dns, :uid, :trans_port, :virt_addr

    def initialize
      check_deps
      @dns = search_dns
      @uid = search_uid
      @trans_port = search_trans_port
      @virt_addr = search_virt_addr
    end

    private 

    def check_deps
      Spior::Install::check_base
      Spior::Copy::config_files
      verify_service
    end

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

    def verify_service
      if TTY::Which.exist?('systemctl')
        state = `systemctl is-active tor`.chomp
        if state == 'active'
          #puts "Restart tor"
          system('sudo systemctl restart tor')
        else
          #puts "Start tor"
          system('sudo systemctl start tor')
        end
      else
        Msg.for_no_systemd
      end
    end
  end
end
