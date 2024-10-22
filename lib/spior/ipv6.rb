# frozen_string_literal: true

require 'auth'
require 'interfacez'

module Spior
  # Block or Allow ipv6 traffic with sysctl
  class Ipv6
    def initialize
      @dest = '/etc/sysctl.d/40-ipv6.conf'
      @cmdline_path = '/proc/cmdline'
      @opened = false
      collect_cmdline_args
      gen_flags
    end

    def allow
      return if check_ipv6_disabled?

      @flags.each { |f| Helpers.cmd("sysctl -q -w '#{f}=0'") }
      Msg.p 'ipv6 allowed'
      Helpers.cmd("rm #{@dest}") if File.exist? @dest
    end

    def block
      return if check_ipv6_disabled?

      @flags.each { |f| Helpers.cmd("sysctl -q -w '#{f}=1'") }
      Msg.p 'ipv6 blocked'
    end

    def block_persist
      return if check_ipv6_disabled?

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

    def collect_cmdline_args
      if !File.exist?(@cmdline_path) || !File.readable?(@cmdline_path)
        @opened = false
      else
        @opened = true
        @all_args = File.read(@cmdline_path)
      end
    end

    def check_ipv6_disabled?
      return false unless @opened

      @all_args.split.each do |a|
        return true.to_s if a.match(/^ipv6.disable=1$/)
      end
      false
    end
  end
end
