require 'pathname'
require 'date'
require 'digest'
require_relative 'msg'

module Spior
  class Copy

    def self.config_files
      copy_file("torrc", "/etc/tor/torrc")
      copy_file("resolv.conf", "/etc/resolv.conf")
      copy_file("ipt_mod.conf", "/etc/modules-load.d/ipt_mod.conf")
    end

    def self.restore_files
      backup_exist("/etc/tor/torrc")
      backup_exist("/etc/resolv.conf")
    end

    private

    def self.copy_file(conf, target)
      @config_file = "conf/#{conf}"
      return if check_hash(@config_file, target)
      if File.exist? target then
        if ! previous_copy target
          backup_file(target)
        else
          add_file target
        end
      else
        add_file target
      end
    end

    def self.previous_copy(target)
      backup=`ls #{target}.backup-* | head -n 1`.chomp
      return false if !File.exist?(backup)
      check_hash(backup, target)
    end

    def self.check_hash(src, target)
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
