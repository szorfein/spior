# frozen_string_literal: true

require 'fileutils'
require 'tempfile'
require 'open3'

# Various function for Spior
module Helpers
  def self.auth?
    return :root if Process.uid == '0'
    return :doas if File.exist?('/bin/doas') || File.exist?('/sbin/doas')
    return :sudo if File.exist?('/bin/sudo') || File.exist?('/sbin/sudo')
  end

  def self.cmd(command)
    case auth?
    when :root
      syscmd(command)
    when :doas
      syscmd("doas #{command}")
    when :sudo
      syscmd("sudo #{command}")
    end
  end

  def self.syscmd(cmd)
    Open3.popen2e(cmd) do |_, stdout_and_stderr, wait_thr|
      puts stdout_and_stderr.gets while stdout_and_stderr.gets
      exit_status = wait_thr.value
      raise "Error, Running #{cmd}" unless exit_status.success?
    end
  end

  def self.mv(src, dest)
    if Process::Sys.getuid == '0'
      FileUtils.mv(src, dest)
      FileUtils.chmod 0644, dest
    else
      cmd("mv #{src} #{dest}")
      cmd("chmod 644 #{dest}")
    end
  end

  # Execute program using sudo when permission is required
  class Exec
    def initialize(name)
      @name = name
    end

    def run(args)
      Helpers.cmd("#{@name} #{args}")
    end
  end

  # Class Newfile
  # Create a file and move at the dest
  # === Example
  # string = "nameserver 127.0.0.1"
  # name = "resolv.conf"
  # dest = "/etc"
  # new_file = Helpers::Newfile.new(string, name, dest)
  # new_file.add
  class NewFile
    # Method #new
    # === Parameters
    # * _string_ = string for the whole file
    # * _name_ = name of the file (e.g: resolv.conf)
    # * _dest_ = path (e.g: /etc)
    def initialize(string, name, dest = '/tmp')
      @string = string
      @name = name
      @dest = "#{dest}/#{@name}"
    end

    # Method #add
    # Add the file at @dest
    def add
      @mv = Helpers::Exec.new('mv')
      tmp = Tempfile.new(@name)
      File.write tmp.path, "#{@string}\n"
      puts "move #{tmp.path} to #{@dest}"
      @mv.run("#{tmp.path} #{@dest}")
    end

    def perm(user, perm)
      chown = Helpers::Exec.new('chown')
      chmod = Helpers::Exec.new('chmod')
      chown.run("#{user}:#{user} #{@dest}")
      chmod.run("#{perm} #{@dest}")
    end
  end

  # Class NewSystemd
  # Used to create a systemd service
  #
  # === Example:
  # require Helpers
  # string = <<EOF
  # [Description]
  #
  # [Service]
  # Type=simple
  #
  # [Installation]
  # WantedBy =
  # EOF
  # new_systemd = Helpers::NewSystemd.new(string, "tor.service")
  # new_systemd.add
  class NewSystemd < NewFile
    # Method #new
    # === Parameters:
    # * _string_ = the string of for whole content file
    # * _name_ = the name of the service (e.g: tor.service)
    def initialize(string, name)
      super
      @systemd_dir = search_systemd_dir
      @dest = "#{@systemd_dir}/#{@name}"
    end

    # Method #add
    # Create a temporary file and move
    # the service @name to the systemd directory
    def add
      @systemctl = Helpers::Exec.new('systemctl')
      super
      @systemctl.run('daemon-reload')
    end

    private

    # Method search_systemd_dir
    # Search the current directory for systemd services
    # + Gentoo can install at /lib/systemd/system or /usr/lib/systemd/system
    def search_systemd_dir
      if Dir.exist? '/lib/systemd/system'
        '/lib/systemd/system'
      elsif Dir.exist? '/usr/lib/systemd/system'
        '/usr/lib/systemd/system'
      else
        raise 'No directory systemd found'
      end
    end
  end
end
