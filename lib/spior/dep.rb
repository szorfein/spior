# frozen_string_literal: true

require 'nomansland'
require 'tty-which'

module Spior

  # Dep: install all dependencies for Spior
  module Dep
    extend self

    def looking
      case Nomansland.distro?
      when :archlinux
        Msg.p 'Looking dependencies for Archlinux...'
        installing_deps(%w[iptables tor])
      when :debian
        Msg.p 'Looking dependencies for Debian...'
        installing_deps(%w[iptables tor])
      when :gentoo
        Msg.p 'Looking dependencies for Gentoo...'
        installing_deps(%w[iptables tor])
      when :void
        Msg.p 'Looking dependencies for Voidlinux...'
        installing_deps(%w[iptables tor])
      else
        Msg.report 'Install for your distro is not yet supported.'
      end
    end

    protected

    def installing_deps(names)
      names.map do |n|
        install(n) if !search_dep(n)
      end
      Msg.p 'Dependencies are OK.'
    end

    def install(name)
      Msg.p "Installing #{n}..."
      case Nomansland.installer?
      when :apt_get
        Helpers::Exec.new('apt-get').run("install #{n}")
      when :emerge
        Helpers::Exec.new('emerge').run("-av #{n}")
      when :pacman
        Helpers::Exec.new('pacman').run("-S #{n}")
      when :void
        Helpers::Exec.new('xbps-install').run("-y #{n}")
      when :yum
        Helpers::Exec.new('yum').run("install #{n}")
      end
    end

    def search_dep(name)
      TTY::Which.exist?(name) ? true : false
    end
  end
end
