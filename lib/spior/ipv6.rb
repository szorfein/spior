# frozen_string_literal: true

require 'auth'
require 'interfacez'

module Spior
  # Block or Allow ipv6 traffic with sysctl
  class Ipv6
    def initialize
      @dest = '/etc/sysctl.d/40-ipv6.conf'
      gen_flags
    end

    def allow
      @flags.each { |f| Helpers.cmd("sysctl -w '#{f}=0'") }
      Msg.p 'ipv6 allowed'
      Helpers.cmd("rm #{@dest}") if File.exist? @dest
    end

    def block
      @flags.each { |f| Helpers.cmd("sysctl -w '#{f}=1'") }
      Msg.p 'ipv6 blocked'
    end

    def block_persist
      Auth.new.mkdir '/etc/sysctl.d'
      myflags = []
      @flags.each { |f| myflags << "#{f}=1" }
      File.write('/tmp/flags.conf', myflags.join("\n"))
      Helpers.cmd("cp /tmp/flags.conf #{@dest}")
    end

    private

    def gen_flags
      @flags = ['net.ipv6.conf.all.disable_ipv6',
                'net.ipv6.conf.default.disable_ipv6']
      Interfacez.all { |i| @flags << "net.ipv6.conf.#{i}.disable_ipv6" }
    end
  end
end
