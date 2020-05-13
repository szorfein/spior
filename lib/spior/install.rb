require 'nomansland'
require 'tty-which'
require_relative 'msg'
require_relative 'helpers'

module Spior
  class Install

    def self.dependencies
      base_packages
      mac_update
    end

    def self.check_base
      base_packages
    end

    def self.check_mac
      pkg_mac
    end

    private

    def self.base_packages
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

    def self.pkg_mac
      pkg_name="deceitmac"
      if not TTY::Which.exist?(pkg_name)
        build_pkg(pkg_name)
      end
    end

    def self.mac_update
      pkg_name="deceitmac"
      if TTY::Which.exist?(pkg_name)
        print "Target #{pkg_name} exist, update? [N/y] "
        choice = gets.chomp
        if choice =~ /y|Y/ then
          puts "Update #{pkg_name}..."
          build_pkg(pkg_name)
        end
      else
        puts "Install #{pkg_name}..."
        build_pkg(pkg_name)
      end
    end

    def self.build_pkg(name)
      old_path = Dir.pwd
      system("rm -rf /tmp/#{name}*")
      system("curl -L -o /tmp/#{name}.tar.gz https://github.com/szorfein/#{name}/archive/master.tar.gz")
      Dir.chdir("/tmp")
      system("tar xvf #{name}.tar.gz")
      Dir.chdir("#{name}-master")
      system("sudo make install")
      if TTY::Which.exist?('systemctl')
        if Dir.exist?("/lib/systemd/system")
          puts "lib/systemd"
          system("sudo cp deceitmac@.service /lib/systemd/system/")
        else
          puts "/usr/lib/systemd"
          system("sudo cp deceitmac@.service /usr/lib/systemd/system/")
        end
      end
      Msg.p "pkg #{name} installed"
      Dir.chdir(old_path)
    rescue => e
      Msg.err e
    end
  end
end
