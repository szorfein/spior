#!/usr/bin/env ruby

require 'pathname'

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

  end
end
