Gem::Specification.new do |s|
  s.name = "spior"
  s.summary = "A tool to make TOR your default gateway"
  s.description = File.read(File.join(File.dirname(__FILE__), "README.md"))
  s.version = "0.0.2"
  s.requirements << 'tor'
  s.requirements << 'sudo'
  s.requirements << 'iptables'
  s.platform = Gem::Platform::RUBY
  s.author = ['szorfein']
  s.homepage = 'https://github.com/szorfein/spior'
  s.email = 'szorfein@protonmail.com'
  s.required_ruby_version = '>=2.4'
  s.files = `git ls-files`.split(" ")
  s.files.reject! { |fn| fn.include? "certs" }
  s.executables = [ 'spior' ]
  s.test_files = Dir["test/test_*.rb"]
  s.licenses = ['MIT']
  s.cert_chain = ['certs/szorfein.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/
  s.add_runtime_dependency('rainbow', '3.0.0')
end
