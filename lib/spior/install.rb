require 'nomansland'
require_relative 'msg'

module Spior
  class Install

    def self.dependencies
      base_packages
      pkg_mac
    end

    private

    def self.base_packages
      case Nomansland::installer?
      when :emerge
        system('sudo emerge -av --changed-use tor iptables')
      when :pacman
        system('sudo pacman -S --needed tor iptables')
      when :yum
        system('sudo yum install tor iptables')
      else
        system('sudo apt-get tor iptables')
      end
    end

    def self.pkg_mac
      pkg_name="deceitmac"
      if File.exist?("/usr/local/bin/#{pkg_name}")
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
      system("rm -rf /tmp/#{name}*")
      system("curl -L -o /tmp/#{name}.tar.gz https://github.com/szorfein/#{name}/archive/master.tar.gz")
      Dir.chdir("/tmp")
      system("tar xvf #{name}.tar.gz")
      Dir.chdir("#{name}-master")
      system("sudo make install")
      Msg.p "pkg #{name} installed"
    rescue => e
      Msg.err e
    end
  end
end
