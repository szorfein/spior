require 'nomansland'
require 'date'
require 'digest'
require_relative 'msg'

module Spior
  class Copy

    def self.config_files
      @conf_dir = File.expand_path('../..' + '/conf', __dir__)
      copy_torrc
      copy_file(@conf_dir + "/resolv.conf", "/etc/resolv.conf")
      copy_file(@conf_dir + "/ipt_mod.conf", "/etc/modules-load.d/ipt_mod.conf")
    end

    def self.restore_files
      backup_exist("/etc/tor/torrc")
      backup_exist("/etc/resolv.conf")
    end

    def self.search_systemd_dir
      if Dir.exist?("/usr/lib/systemd/system")
        @systemd_dir = '/usr/lib/systemd/system'
      elsif Dir.exist?("/lib/systemd/system")
        @systemd_dir = '/lib/systemd/system'
      else
        Msg.report "Directory systemd/system is no found on your system."
        exit(-1)
      end
    end

    def self.systemd_services
      search_systemd_dir
      case Nomansland::installer?
      when :gentoo
        Msg.p "Copy #{@conf_dir}/iptables.service"
        copy_file(@conf_dir + "/iptables.service", @systemd_dir + "/iptables.service")
      end
    end

    private

    def self.copy_file(conf, target)
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

    def self.copy_torrc
      case Nomansland::distro?
      when :archlinux
        copy_file(@conf_dir + "/torrc/torrc_archlinux", "/etc/tor/torrc")
      else
        copy_file(@conf_dir + "/torrc/torrc_default", "/etc/tor/torrc")
        Msg.report "If tor fail to start with the default torrc"
      end
    end

    def self.previous_copy(target)
      backup=`ls #{target}.backup-* | head -n 1`.chomp
      return false if !File.exist?(backup)
      check_hash(backup, target)
    end

    def self.check_hash(src, target)
      return if not File.exist?(target)
      sha256conf = Digest::SHA256.file src
      sha256target = Digest::SHA256.file target
      sha256conf === sha256target
    end

    def self.backup_file(target)
      d = DateTime.now
      backup = target + ".backup-" + d.strftime('%b-%d_%I-%M')
      system("sudo cp -a #{target} #{backup}")
      puts "Renamed file #{backup}"
    end

    def self.add_file(target)
      system("sudo cp -a #{@config_file} #{target}")
      Msg.p "File #{@config_file} has been successfully copied at #{target}"
    end

    def self.backup_exist(target)
      backup=`ls #{target}.backup-* | head -n 1`.chomp
      if File.exist? backup
        if ! check_hash(target, backup)
          system("sudo cp -a #{backup} #{target}")
          Msg.p "Restored #{backup}"
        end
      else
        puts "No found previous backup for #{target}"
      end
    end
  end
end
