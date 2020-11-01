require 'tty-which'
require 'nomansland'

module Spior
  module Clear
    extend self

    def all
      iptables
      Spior::Copy.new.restore
    end

    private

    def iptables
      puts "Clearing rules.."
      ipt = Spior::Iptables::Default.new
      ipt.stop!
      #if File.exist?("/var/lib/iptables/rules-save")
      #  ipt_restore "/var/lib/iptables/rules-save"
      #elsif File.exist?("/etc/iptables/rules.save")
      #  ipt_restore "/etc/iptables/iptables.rules"
      #elsif File.exist?("/etc/iptables.rules")
      #  ipt_restore "/etc/iptables.rules"
      #else
        #Msg.p "Couldn't find any previous rules for iptables, create basic rules..."
        ipt.run!
      #end
    end

    def ipt_restore(path)
      puts "Restoring rules #{path}..."
      Helpers::Exec.new("iptables-restore").run("#{path}")
    end
  end
end
