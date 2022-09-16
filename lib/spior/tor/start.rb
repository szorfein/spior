# frozen_string_literal: true

require 'nomansland'
require 'tempfile'

module Spior
  module Tor
    extend self

    # start should start the Tor service on your distribution
    def start
      tmp_file = Tempfile.new('torrc')

      Tor::Config.new(tmp_file).generate

      # Use Kernel.spawn here
      x("tor -f #{tmp_file.path}") unless File.zero? tmp_file.path

      case Nomansland.init?
      when :systemd
        start_systemd
      when :openrc
        Msg.p 'Starting Tor with Openrc...'
        Helpers::Exec.new('/etc/init.d/tor').run('start')
      when :runit
        start_runit
      else
        Msg.report "Don't known yet how to start Tor for your system."
      end
    end

    protected

    def start_systemd
      state = `systemctl is-active tor`.chomp
      unless state == 'active'
        Msg.p 'Starting Tor with Systemd...'
        Helpers::Exec.new('systemctl').run('start tor')
      end
    end

    def start_runit
      Msg.p 'Starting Tor with Runit...'
      if File.exist? '/var/service/tor'
        Helpers::Exec.new('sv').run('start tor')
      else
        Helpers::Exec.new('ln').run('-s /etc/sv/tor /var/service/tor')
      end
    end

    private

    def x(arg)
      auth = (Process::Sys.getuid == '0' ? '' : 'sudo')
      pid = spawn("#{auth} #{arg}", out: '/dev/null') or raise 'Error'
      Process.wait pid
    end
  end
end
