require 'digest'

module Spior
  class Copy
    def initialize
      @cp = Helpers::Exec.new("cp -a")
      @files = []
      search_conf_dir
      config_files
      list
    end

    def save
      @files.each { |f|
        backup = "#{f}_backup"
        if ! File.exist? backup
          Msg.p "#{f} saved"
          @cp.run("#{f} #{backup}")
        end
      }
    end

    def restore
      @files.each { |f|
        backup = "#{f}_backup"
        if File.exist? backup
          Msg.p "#{f} restored"
          @cp.run("#{backup} #{f}")
        end
      }
    end

    private

    def config_files
      copy_file("#{@conf_dir}/ipt_mod.conf", "/etc/modules-load.d/ipt_mod.conf")
    end

    def list
      add "/etc/resolv.conf"
      add "/etc/tor/torrc"
      add "/etc/systemd/resolved.conf"
      add "/var/lib/iptables/rules-save" # gentoo
      add "/etc/iptables/iptables.rules" # arch
      add "/etc/iptables/rules.v4" # debian
    end

    def add(file)
      @files << file if File.exist? file
    end

    def search_conf_dir
      # ebuild on gentoo copy the ext dir at lib/ext
      @conf_dir = File.expand_path('../..' + '/lib/ext', __dir__)
      if ! Dir.exist?(@conf_dir)
        @conf_dir = File.expand_path('../..' + '/ext', __dir__)
      end
    end

    def previous_copy(target)
      backup=`ls #{target}.backup-* | head -1`.chomp
      return false if ! File.exist? backup
      check_hash(backup, target)
    end

    def add_file(target)
      @cp.run("#{@config_file} #{target}")
      Msg.p "File #{@config_file} has been successfully copied at #{target}"
    end

    def copy_file(conf, target)
      @config_file = conf
      add_file target if ! File.exist? target
      return if check_hash(@config_file, target)
      add_file target
    end

    def check_hash(src, target)
      return if not File.exist?(target)
      sha256conf = Digest::SHA256.file src
      sha256target = Digest::SHA256.file target
      sha256conf === sha256target
    end
  end
end
