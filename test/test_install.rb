require 'minitest/autorun'
require_relative '../lib/spior/install'
require 'pathname'

class TestInstall < Minitest::Test

  def test_sudo_is_installed
    sudo = `which sudo`
    assert_match(/sudo/, sudo, "sudo isn't installed?")
  end

end
