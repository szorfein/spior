# https://github.com/seattlerb/minitest#running-your-tests-
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/test_*.rb"]
end

namespace :gem do
  desc "build the gem"
  task :build do
    Dir["spior*.gem"].each {|f| File.unlink(f) }
    system("gem build spior.gemspec")
    system("gem install spior-0.1.4.gem -P MediumSecurity")
  end
end

task :default => :test
