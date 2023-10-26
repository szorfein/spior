# frozen_string_literal: true

require 'nomansland'
require 'tty-which'

module Spior
  # Dep: install all dependencies for Spior
  module Dep
    module_function

    def looking
      case Nomansland.distro?
      when :archlinux
        installing_deps('Arch', %w[iptables tor])
      when :debian
        installing_deps('Debian', %w[iptables tor])
      when :gentoo
        installing_deps('Gentoo', %w[iptables tor])
      when :void
        installing_deps('Void', %w[iptables tor])
      else
        Msg.report 'Install for your distro is not yet supported.'
      end
    end

    def installing_deps(distro, names)
      names.map do |n|
        Msg.p "Search #{n} for #{distro}..."
        install(n) unless search_dep(n)
      end
    end

    def install(name)
      case Nomansland.installer?
      when :apt_get
        Helpers::Exec.new('apt-get').run("install #{name}")
      when :emerge
        Helpers::Exec.new('emerge').run("-av #{name}")
      when :pacman
        Helpers::Exec.new('pacman').run("-S #{name}")
      when :void
        Helpers::Exec.new('xbps-install').run("-y #{name}")
      when :yum
        Helpers::Exec.new('yum').run("install #{name}")
      end
    end

    def search_dep(name)
      TTY::Which.exist?(name) ? true : false
    end
  end
end
