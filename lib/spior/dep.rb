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
        installing_deps('pacman -S', %w[iptables tor])
      when :debian
        installing_deps('apt-get install', %w[iptables tor])
        use_iptables
      when :gentoo
        installing_deps('emerge -av', %w[iptables tor])
      when :void
        installing_deps('xbps-install -S', %w[iptables tor])
      when :fedora
        installing_deps('dnf install -y', %w[iptables tor])
      when :suse
        installing_deps('zypper install -y', %w[iptables tor])
      else
        Msg.report 'Install for your distro is not yet supported.'
      end
    end

    def installing_deps(distro_cmd, names)
      names.map do |n|
        Msg.p "Search #{n}..."
        install(distro_cmd, n) unless search_dep(n)
      end
    end

    def install(cmd, package)
      Helpers.cmd("#{cmd} #{package}")
    end

    def search_dep(name)
      TTY::Which.exist?(name) ? true : false
    end

    # https://wiki.debian.org/iptables
    def use_iptables
      Helpers.cmd('update-alternatives --set iptables /usr/sbin/iptables-legacy')
      Helpers.cmd('update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy')
      Helpers.cmd('update-alternatives --set arptables /usr/sbin/arptables-legacy')
      Helpers.cmd('update-alternatives --set ebtables /usr/sbin/ebtables-legacy')
    end
  end
end
