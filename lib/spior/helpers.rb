require 'fileutils'
require 'tempfile'

module Helpers
  class Exec
    def initialize(name)
      @search_uid = Process::Sys.getuid
      @name = name
    end

    def run(args)
      if @search_uid == '0' then
        #puts "found root - uid #{@search_uid}"
        system(@name + " " + args)
      else
        #puts "no root - call sudo - uid #{@search_uid}"
        system("sudo " + @name + " " + args)
      end
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
    def initialize(string, name, dest = "/tmp")
      @string = string
      @name = name
      @dest = dest + "/" + @name
    end

    # Method #add
    # Add the file at @dest
    def add
      @mv = Helpers::Exec.new("mv")
      tmp = Tempfile.new(@name)
      File.open(tmp.path, 'w') do |file|
        file.puts @string
      end
      @mv.run("#{tmp.path} #{@dest}")
    end

    def perm(user, perm)
      chown = Helpers::Exec.new("chown")
      chmod = Helpers::Exec.new("chmod")
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
      @dest = @systemd_dir + "/" + @name
    end

    # Method #add
    # Create a temporary file and move
    # the service @name to the systemd directory
    def add
      @systemctl = Helpers::Exec.new("systemctl")
      super
      @systemctl.run("daemon-reload")
    end

    private
    # Method search_systemd_dir
    # Search the current directory for systemd services
    # + Gentoo can install at /lib/systemd/system or /usr/lib/systemd/system
    def search_systemd_dir
      if Dir.exist? "/lib/systemd/system"
        "/lib/systemd/system"
      elsif Dir.exist? "/usr/lib/systemd/system"
        "/usr/lib/systemd/system"
      else
        raise "No directory systemd found"
        exit
      end
    end
  end
end
