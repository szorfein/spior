require 'nomansland'
require 'tty-which'

module Spior
  class Install
    class << self
      def check_deps
        base_packages
      end

      private

      def base_packages
        if not TTY::Which.exist?('iptables') or not TTY::Which.exist?('tor')
          case Nomansland::installer?
          when :emerge
            emerge = Helpers::Exec.new("emerge -av --changed-use")
            emerge.run("tor iptables")
          when :pacman
            pacman = Helpers::Exec.new("pacman -S --needed")
            pacman.run("tor iptables")
          when :yum
            yum = Helpers::Exec.new("yum install")
            yum.run("tor iptables")
          else
            apt_get = Helpers::Exec.new("apt-get install")
            apt_get.run("tor iptables iptables-persistent")
          end
        end
      end
    end
  end
end
