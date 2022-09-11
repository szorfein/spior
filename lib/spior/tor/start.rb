# frozen_string_literal: true

require 'nomansland'
require 'tempfile'

module Spior
  module Tor
    module_function

    def start
      tmp_file = Tempfile.new('torrc')

      Tor::Config.new(tmp_file).generate

      # Use Kernel.spawn here
      x("tor -f #{tmp_file.path}")

      case Nomansland.init?
      when :systemd
        Msg.p 'Detect a Systemd system, starting Tor...'
        state = `systemctl is-active tor`.chomp
        unless state == 'active'
          Helpers::Exec.new('systemctl').run('start tor')
        end
      when :runit
        Msg.p 'Detect a Runit system, starting Tor...'
        unless File.exist? '/var/service/tor'
          Helpers::Exec.new('ln').run('-s /etc/sv/tor /var/service/tor')
        else
          Helpers::Exec.new('sv').run('start tor')
        end
      when :openrc
        Msg.p 'Detect an Openrc system, starting Tor...'
        Helpers::Exec.new('/etc/init.d/tor').run('start')
      else
        Msg.report "Don't known yet how to start Tor for your system."
      end
    end

    def x(arg)
      auth = Process::Sys.getuid == '0' ? '' : 'sudo'
      pid = spawn("#{auth} #{arg}", :out => '/dev/null') or raise 'Error'
      Process.wait pid
    end
  end
end
