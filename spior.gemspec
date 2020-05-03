Gem::Specification.new do |s|
  s.name = "spior"

  s.summary = "A tool to make TOR your default gateway and randomize your hardware"
  s.description = <<-EOF 
    A tool to make TOR your default gateway and randomize your hardware
    Status: not yet functionnal, please wait for the next releases !"
  EOF

  s.metadata = {
    "changelog_uri" => "https://github.com/szorfein/spior/blob/master/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/szorfein/spior/issues",
    "wiki_uri" => "https://github.com/szorfein/spior"
  }

  s.version = "0.0.4"
  s.requirements << 'tor'
  s.requirements << 'sudo'
  s.requirements << 'iptables'
  s.requirements << 'deceitmac'
  s.platform = Gem::Platform::RUBY
  s.author = ['szorfein']
  s.homepage = 'https://github.com/szorfein/spior'
  s.email = 'szorfein@protonmail.com'
  s.required_ruby_version = '>=2.4'
  s.files = `git ls-files`.split(" ")
  s.files.reject! { |fn| fn.include? "certs" }
  s.files.reject! { |fn| fn.include? "Makefile" }
  s.executables = [ 'spior' ]
  s.test_files = Dir["test/test_*.rb"]
  s.licenses = ['MIT']
  s.cert_chain = ['certs/szorfein.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/
  s.add_runtime_dependency('rainbow', '3.0.0')
  s.add_runtime_dependency('interfacez', '1.0.3')
end
