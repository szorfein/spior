# frozen_string_literal: true

require 'digest'

module Spior
  module Tor
    # Generate a config file (torrc) for Spior
    class Config
      # ==== Attributes
      #
      # * +filename+ - A reference to a tempfile like filename=Tempfile.new('foo')
      #
      def initialize(filename)
        @filename = filename
        @content = ['# Generated by Spior, don\'t edit.', 'RunAsDaemon 1',
                    'ClientOnly 1', 'SocksPort 0']
        @content_torrc = []
      end

      # Generate a `torrc` compatible file for Spior
      # Use value from Spior::CONFIG
      def generate
        generate_content(@content)
        return if @content.length == 4

        File.write @filename.path, "#{@content.join('\n')}\n"
        Msg.p 'Generating Tor config...'
      end

      # Save current Tor options (Spior::CONFIG) in /etc/tor/torrc
      # Only if theses options are not alrealy present
      def backup
        generate_content(@content_torrc)
        outfile = File.open(@filename.path, 'w')
        outfile.puts(File.read('/etc/tor/torrc'))
        outfile.puts(@content_torrc.join("\n")) if @content_torrc != []
        outfile.chmod(644)
        outfile.close

        Msg.p 'Saving Tor options...'
        move(@filename.path, '/etc/tor/torrc')
      end

      protected

      def generate_content(content)
        adding content, 'AutomapHostsOnResolve 1'
        adding content, "DNSPort #{CONFIG.dns_port}"
        adding content, "VirtualAddrNetworkIpv4 #{CONFIG.virt_addr}"
        adding content, "TransPort #{CONFIG.trans_port} IsolateClientAddr
               IsolateClientProtocol IsolateDestAddr IsolateDestPort"
      end

      private

      def search(option_name)
        File.open('/etc/tor/torrc') do |f|
          f.each do |line|
            return Regexp.last_match(1) if line.match(/#{option_name} ([a-z0-9]*)/i)
          end
        end
        false
      end

      def adding(content, option)
        o = option.split(' ')
        all = o[1..o.length].join(' ')
        return if search(o[0])

        content << "#{o[0]} #{all}"
      end

      def digest_match?(src, dest)
        md5_src = Digest::MD5.file src
        md5_dest = Digest::MD5.file dest
        md5_src == md5_dest
      end

      # Permission for Archlinux on a torrc are chmod 644, chown root:root
      def fix_perm(file)
        if Process::Sys.getuid == '0'
          file.chown(0, 0)
        else
          Helpers::Exec.new('chown').run("root:root #{file}")
        end
      end

      def move(src, dest)
        return if digest_match? src, dest

        fix_perm(@filename.path)
        if Process::Sys.getuid == '0'
          FileUtils.mv(src, dest)
        else
          Helpers::Exec.new('mv').run("#{src} #{dest}")
        end
      end
    end
  end
end
