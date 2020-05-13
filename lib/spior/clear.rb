require 'tty-which'
require 'nomansland'
require_relative 'copy'
require_relative 'msg'
require_relative 'helpers'

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
        Msg.p "I couldn't find any old rules for iptables to restore, skipping..."
      end
    end

    def ipt_restore(path)
      puts "Restoring rules #{path}..."
      Helpers::Exec.new("iptables-restore").run("#{path}")
    end

    def rez_configs
      Spior::Copy::restore_files
    end
  end
end
