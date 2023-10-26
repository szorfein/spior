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
        @tmp_spior_rules = Tempfile.new('spior_rules')
        @save_path = search_iptables_config
      end

      def save
        save_rules(@tmp_iptables_rules)
        insert_comment(@tmp_spior_rules, @tmp_iptables_rules)
        create_file(@tmp_spior_rules, @save_path)
        Msg.p "Iptables rules saved at #{@save_path}"
      end

      def restore
        return if restoring_older_rules(@save_path)

        Msg.p 'Adding clearnet navigation...'
        Iptables::Default.new.run!
      end

      protected

      def save_rules(tmp_file)
        Msg.p 'Saving Iptables rules...'
        Helpers::Exec.new('iptables-save').run("> #{tmp_file.path}")
      end

      def insert_comment(spior_file, iptable_file)
        outfile = File.open(spior_file.path, 'w')
        outfile.puts '# Rules saved by Spior.'
        outfile.puts(File.read(iptable_file.path))
        outfile.close
      end

      def search_for_comment(filename)
        File.open(filename) do |f|
          f.each do |line|
            return true if line.match(/saved by Spior/)
          end
        end
        false
      end

      def move(src, dest)
        if Process::Sys.getuid == '0'
          FileUtils.mv(src, dest)
        else
          Helpers::Exec.new('mv').run("#{src} #{dest}")
        end
      end

      def create_file(tmpfile, dest)
        if File.exist? dest
          if search_for_comment(dest)
            Msg.p "Older Spior rules found #{dest}, erasing..."
          else
            Msg.p "File exist #{dest}, create backup #{dest}-backup..."
            move(dest, "#{dest}-backup")
          end
        end
        move(tmpfile.path, dest)
      end

      def restoring_older_rules(filename)
        files = %W[#{filename}-backup #{filename}]
        files.each do |f|
          next unless File.exist?(f) || search_for_comment(f)

          Iptables::Root.new.stop!
          Msg.p "Found older rules #{f}, restoring..."
          Helpers::Exec.new('iptables-restore').run(f)
          return true
        end
        false
      end

      private

      def search_iptables_config
        case Nomansland.distro?
        when :archlinux || :void
          '/etc/iptables/iptables.rules'
        when :debian
          '/etc/iptables.up.rules'
        when :gentoo
          '/var/lib/iptables/rules-save'
        else
          Msg.report 'I don`t know where you distro save the rules for iptables yet'
        end
      end
    end
  end
end
