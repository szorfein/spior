require 'nomansland'
require 'date'
require 'digest'
require_relative 'msg'
require_relative 'helpers'

module Spior
  class Copy
    class << self

      def config_files
        @cp = Helpers::Exec.new("cp -a")
        search_conf_dir
        copy_torrc
        copy_file(@conf_dir + "/resolv.conf", "/etc/resolv.conf")
        copy_file(@conf_dir + "/ipt_mod.conf", "/etc/modules-load.d/ipt_mod.conf")
      end

      def search_conf_dir
        # ebuild on gentoo copy the ext dir at lib/ext
        @conf_dir = File.expand_path('../..' + '/lib/ext', __dir__)
        if not Dir.exist?(@conf_dir)
          @conf_dir = File.expand_path('../..' + '/ext', __dir__)
        end
      end

      def restore_files
        @cp = Helpers::Exec.new("cp -a")
        backup_exist("/etc/tor/torrc")
        backup_exist("/etc/resolv.conf")
      end

      def search_systemd_dir
        if Dir.exist?("/usr/lib/systemd/system")
          @systemd_dir = '/usr/lib/systemd/system'
        elsif Dir.exist?("/lib/systemd/system")
          @systemd_dir = '/lib/systemd/system'
        else
          Msg.report "Directory systemd/system is no found on your system."
          exit(-1)
        end
      end

      def systemd_services
        @cp = Helpers::Exec.new("cp -a")
        search_systemd_dir
        case Nomansland::installer?
        when :gentoo
          Msg.p "Copy #{@conf_dir}/iptables.service"
          copy_file(@conf_dir + "/iptables.service", @systemd_dir + "/iptables.service")
        end
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

      def copy_torrc
        case Nomansland::distro?
        when :archlinux
          copy_file(@conf_dir + "/torrc/torrc_archlinux", "/etc/tor/torrc")
        else
          copy_file(@conf_dir + "/torrc/torrc_default", "/etc/tor/torrc")
          Msg.report "If tor fail to start with the default torrc"
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
    end
  end
end
