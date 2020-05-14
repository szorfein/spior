require 'pathname'
require 'nomansland'
require 'tty-which'
require_relative 'msg'
require_relative 'install'
require_relative 'copy'
require_relative 'helpers'

module Spior
  class Tor
    attr_accessor :dns, :uid, :trans_port, :virt_addr

    def initialize
      @systemctl = Helpers::Exec.new("systemctl")
      check_deps
      @dns = search_dns
      @uid = search_uid
      @trans_port = search_trans_port
      @virt_addr = search_virt_addr
    end

    private 

    def check_deps
      Spior::Install::check_deps
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
          @systemctl.run('restart tor')
        else
          #puts "Start tor"
          @systemctl.run('start tor')
        end
      else
        Msg.for_no_systemd
      end
    end
  end
end
