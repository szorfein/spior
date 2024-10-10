# frozen_string_literal: true

require 'tempfile'
require 'fileutils'
require 'nomansland'

module Spior
  module Iptables
    # Iptables::Rules, used to save or restore iptables rules
    class Rules
      def initialize
        @tmp_iptables_rules = Tempfile.new('iptables_rules')
        @save_path = search_iptables_config
      end

      def save
        Helpers.cmd("iptables-save > #{@tmp_iptables_rules.path}")
        Helpers.mv(@tmp_iptables_rules.path, @save_path)
        Msg.p "Iptables rules saved at #{@save_path}"
      end

      def restore
        return if restoring_older_rules

        Msg.p 'Adding clearnet navigation...'
        Iptables::Default.new.run!
      end

      protected

      def restoring_older_rules
        files = %w[/etc/iptables/simple_firewall.rules /usr/share/iptables/simple_firewall.rules]
        files.each do |f|
          next unless File.exist?(f)

          Iptables::Root.new.stop!
          Msg.p "Found older rules #{f}, restoring..."
          Helpers.cmd("cp #{f} #{@save_path}")
          Helpers.cmd("iptables-restore < #{@save_path}")
          return true
        end
        false
      end

      private

      def search_iptables_config
        case Nomansland.distro?
        when :debian
          '/etc/iptables.up.rules'
        when :gentoo
          '/var/lib/iptables/rules-save'
        else
          '/etc/iptables/iptables.rules'
        end
      end
    end
  end
end
