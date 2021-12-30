require 'nomansland'
require 'tty-which'

module Spior
  module Dep
    def self.check
      deps = [ 'iptables', 'tor' ]
      is_ok = true
      Msg.p 'Searching dependencies...'
      deps.each {|dep|
        unless TTY::Which.exist? dep
          Msg.err "-> #{dep} is lacked."
          is_ok = false
        end
      }
      exit 1 unless is_ok
    end

    def self.install
      case Nomansland::installer?
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
      exit 0
    end
  end
end
