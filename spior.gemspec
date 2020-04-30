Gem::Specification.new do |s|
  s.name = "spior"
  s.summary = "Make TOR your default gateway"
  s.description = File.read(File.join(File.dirname(__FILE__), "README.md"))
  s.version = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.author = "szorfein"
  s.homepage = "https://github.com/szorfein/spior"
  s.email = "szorfein@protonmail.com"
  s.required_ruby_version = '>=2.4'
  s.files = Dir['**/**']
  s.executables = [ 'spior' ]
  s.test_files = Dir["test/test_*.rb"]
  s.licenses = "MIT"
end
