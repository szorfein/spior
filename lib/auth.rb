# lib/auth.rb
# frozen_string_literal: true

require 'open3'

# When action require privilege, Auth search on the system for sudo or doas.
class Auth
  def initialize
    @auth = search_app
  end

  def mkdir(path)
    return if Dir.exist?(path)

    x("mkdir -p #{path}")
  end

  def sysctl(flag, value)
    return if flag.nil?

    x("sysctl -w #{flag}=#{value}")
  end

  def write(content, file)
    temp = Tempfile.new
    File.write(temp.path, "#{content}\n")
    x("cp #{temp.path} #{file}")
  end

  protected

  def search_app
    if File.exist?('/usr/bin/doas') || File.exist?('/bin/doas')
      'doas'
    elsif File.exist?('/usr/bin/sudo') || File.exist?('/bin/sudo')
      'sudo'
    else
      warn 'No auth program found, Spior need few privileges.'
    end
  end

  private

  def x(args)
    Open3.popen2e("#{@auth} #{args}") do |_, stdout, wait_thr|
      puts stdout.gets while stdout.gets

      exit_status = wait_thr.value
      raise "An error expected with #{@auth} #{args}" unless exit_status.success?
    end
  end
end
