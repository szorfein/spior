require 'nomansland'
require 'date'
require 'digest'

module Spior
  class Copy
    class << self

      def config_files
        @cp = Helpers::Exec.new("cp -a")
        search_conf_dir
        copy_file(@conf_dir + "/ipt_mod.conf", "/etc/modules-load.d/ipt_mod.conf")
      end

      def backup(file, re = nil)
        return if regex_match?(file, re)
        @cp = Helpers::Exec.new("cp -a")
        backup = file + "_backup"
        if File.exist? backup
          puts "File #{backup} exist with content:"
          system("head -n 10 #{backup}")
          print "...\nOverwrite this copy? (N/y) "
          case gets.chomp
          when /^y|^Y/
            @cp.run("#{file} #{backup}")
            Msg.p "Overwrite #{file}"
          end
        else
          @cp.run("#{file} #{backup}")
          Msg.p "#{file} saved"
        end
      end

      def search_conf_dir
        # ebuild on gentoo copy the ext dir at lib/ext
        @conf_dir = File.expand_path('../..' + '/lib/ext', __dir__)
        if not Dir.exist?(@conf_dir)
          @conf_dir = File.expand_path('../..' + '/ext', __dir__)
        end
      end

      def restore(file)
        @cp = Helpers::Exec.new("cp -a")
        backup = file + "_backup"
        if File.exist? backup
          @cp.run("#{backup} #{file}")
        end
      end

      def restore_files
        restore("/etc/tor/torrc")
        restore("/etc/resolv.conf")
      end

      private

      def copy_file(conf, target)
        @config_file = conf
        return if check_hash(@config_file, target)
        if File.exist? target then
          if ! previous_copy target
            backup_file(target)
          end
          add_file target
        else
          add_file target
        end
      end

      def previous_copy(target)
        backup=`ls #{target}.backup-* | head -n 1`.chomp
        return false if !File.exist?(backup)
        check_hash(backup, target)
      end

      def check_hash(src, target)
        return if not File.exist?(target)
        sha256conf = Digest::SHA256.file src
        sha256target = Digest::SHA256.file target
        sha256conf === sha256target
      end

      def backup_file(target)
        d = DateTime.now
        backup = target + ".backup-" + d.strftime('%b-%d_%I-%M')
        @cp.run("#{target} #{backup}")
        puts "Renamed file #{backup}"
      end

      def add_file(target)
        @cp.run("#{@config_file} #{target}")
        Msg.p "File #{@config_file} has been successfully copied at #{target}"
      end

      def backup_exist(target)
        backup=`ls #{target}.backup-* | head -n 1`.chomp
        if File.exist? backup
          if ! check_hash(target, backup)
            @cp.run("#{backup} #{target}")
            Msg.p "Restored #{backup}"
          end
        else
          puts "No found previous backup for #{target}"
        end
      end

      def regex_match?(infile, re = nil)
        return unless re
        File.open(infile, 'r') do |file|
          file.each do |line|
            return true if line =~ re
          end
        end
        false
      end
    end
  end
end
