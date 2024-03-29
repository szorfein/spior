# lib/ipv6.rb
# frozen_string_literal: true

require 'auth'
require 'interfacez'

module Spior
  # Block or Allow ipv6 traffic with sysctl
  class Ipv6
    def initialize
      @changed = false
    end

    def allow
      apply_option('net.ipv6.conf.all.disable_ipv6', '0')
      apply_option('net.ipv6.conf.default.disable_ipv6', '0')
      Msg.p 'ipv6 allowed' if @changed
    end

    def block
      apply_option('net.ipv6.conf.all.disable_ipv6', '1')
      apply_option('net.ipv6.conf.default.disable_ipv6', '1')
      Msg.p 'ipv6 blocked' if @changed
    end

    def block_persist
      Auth.new.mkdir '/etc/sysctl.d'
      interfaces = ['net.ipv6.conf.all.disable_ipv6 = 1',
                    'net.ipv6.conf.default.disable_ipv6 = 1']
      Interfacez.all { |i| interfaces << "net.ipv6.conf.#{i}.disable_ipv6 = 1" }
      if Process::Sys.getuid == '0'
        File.write('/etc/sysctl.d/40-ipv6.conf', interfaces.join("\n"))
      else
        Auth.new.write(interfaces.join("\n"), '/etc/sysctl.d/40-ipv6.conf')
      end
    end

    private

    def apply_option(flag, value)
      flag_path = flag.gsub('.', '/')
      return unless File.exist?("/proc/sys/#{flag_path}")

      Auth.new.sysctl(flag, value)
      @changed = true
    end
  end
end
