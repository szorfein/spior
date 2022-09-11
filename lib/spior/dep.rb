# frozen_string_literal: true

require 'nomansland'
require 'tty-which'

module Spior

  # Dep: install all dependencies for Spior
  module Dep
    def self.check
      deps = %w[iptables tor]
      is_ok = true
      Msg.p 'Searching dependencies...'
      deps.map do |dep|
        unless TTY::Which.exist? dep
          Msg.err "-> #{dep} is lacked."
          is_ok = false
        end
      end
      exit 1 unless is_ok
    end

    def self.install
      case Nomansland.installer?
      when :emerge
        Helpers::Exec.new('emerge -av').run('tor iptables')
      when :pacman
        Helpers::Exec.new('pacman -S').run('tor iptables')
      when :yum
        Helpers::Exec.new('yum install').run('tor iptables')
      when :void
        Helpers::Exec.new('xbps-install -y').run('tor iptables runit-iptables')
      when :debian
        Helpers::Exec.new('apt-get install').run('tor iptables iptables-persistent')
      else
        Msg.report 'Your system is not yet supported.'
      end
      exit
    end
  end
end
