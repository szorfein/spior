require 'tty-which'
require 'nomansland'
require_relative 'copy'
require_relative 'msg'

module Spior
  module Clear
    extend self

    def all
      iptables
      rez_configs
    end

    private

    def iptables
      puts "Clearing rules.."
      Spior::Iptables::flush_rules
      if File.exist?("/var/lib/iptables/rules-save")
        ipt_restore "/var/lib/iptables/rules-save"
      elsif File.exist?("/etc/iptables/rules.save")
        ipt_restore "/etc/iptables/iptables.rules"
      elsif File.exist?("/etc/iptables.rules")
        ipt_restore "/etc/iptables.rules"
      else
        Msg.report "Do not known where search you previous iptables rules"
      end
    end

    def ipt_restore(path)
      puts "Restoring rules #{path}..."
      system("sudo iptables-restore #{path}")
    end

    def rez_configs
      Spior::Copy::restore_files
    end
  end
end
