# frozen_string_literal: true

require File.dirname(__FILE__) + '/lib/spior/version'

Gem::Specification.new do |s|
  s.name = 'spior'
  s.version = Spior::VERSION
  s.summary = 'A tool to make TOR your default gateway'
  s.description = <<-DESC
    A tool to make TOR your default gateway
  DESC
  s.metadata = {
    'changelog_uri' => 'https://github.com/szorfein/spior/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/szorfein/spior/issues',
    'wiki_uri' => 'https://github.com/szorfein/spior'
  }
  s.author = ['szorfein']

  s.platform = Gem::Platform::RUBY

  s.licenses = ['MIT']
  s.email = 'szorfein@protonmail.com'
  s.homepage = 'https://github.com/szorfein/spior'

  s.files = `git ls-files`.split(" ")
  s.files.reject! { |fn| fn.include? 'certs' }
  s.files.reject! { |fn| fn.include? 'Makefile' }
  s.executables = ['spior']

  s.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt']

  s.test_files = Dir["test/test_*.rb"]
  s.cert_chain = ['certs/szorfein.pem']
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if Regexp.last_match(0) =~ /gem\z/

  s.requirements << 'tor'
  s.requirements << 'iptables'

  s.required_ruby_version = '>=2.6'

  s.add_runtime_dependency('interfacez', '1.0.3')
  s.add_runtime_dependency('nomansland', '0.0.3')
  s.add_runtime_dependency('rainbow', '3.0.0')
  s.add_runtime_dependency('tty-which', '0.4.2')
end
