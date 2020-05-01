#!/usr/bin/env ruby

require 'pathname'
require 'date'
require 'digest'
require_relative 'msg'

module Spior
  class Install

    def self.dependencies
      if Pathname.new("/usr/bin/emerge")
        puts "Install with emerge..."
        system('sudo emerge -av --changed-use tor iptables')

      elsif Pathname.new("/usr/bin/pacman")
        puts "Install with pacman..."
        system('sudo pacman -S --needed tor iptables')

      elsif Pathname.new("/usr/bin/apt-get")
        puts "Install with apt-get"
        system('sudo apt-get tor iptables')
      end
    end

    def self.config_files
      copy_file("torrc", "/etc/tor/torrc")
      copy_file("resolv.conf", "/etc/resolv.conf")
      copy_file("ipt_mod.conf", "/etc/modules-load.d/ipt_mod.conf")
    end

    private

    def self.copy_file(conf, target)
      @config_file = "conf/#{conf}"
      return if check_hash(target)
      if File.exist? target then
        print "Target #{target} exist, backup and replace? [N/y] "
        choice = gets.chomp
        if choice =~ /y|Y/ then
          backup_file(target)
          puts "copy file #{@config_file} at #{target}"
          system("sudo cp -a #{@config_file} #{target}")
        end
      else
        puts "copy file #{@config_file} at #{target}"
        system("sudo cp -a #{@config_file} #{target}")
      end
    end

    def self.check_hash(target)
      return unless File.exist? target
      sha256conf = Digest::SHA256.file @config_file
      sha256target = Digest::SHA256.file target
      if sha256conf === sha256target then
        Msg.p "file #{target} alrealy exist, skip"
        return true
      end
      return false
    end

    def self.backup_file(target)
      d = DateTime.now
      backup = target + ".backup-" + d.strftime('%b-%d_%I-%M')
      system("sudo cp -a #{target} #{backup}")
      puts "Renamed file #{backup}"
    end
  end
end
