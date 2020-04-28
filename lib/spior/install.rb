#!/usr/bin/env ruby

require 'pathname'

module Spior
  class Install

    def self.dependencies
      if Pathname.new("/usr/bin/emerge") then
        puts "Install with emerge..."
        system('sudo emerge -av --changed-use tor iptables')

      elsif Pathname.new("/usr/bin/pacman") then
        puts "Install with pacman..."
        system('sudo pacman -S --needed tor iptables')
      end
    end

  end
end
