# frozen_string_literal: true

# https://github.com/seattlerb/minitest#running-your-tests-
require 'rake/testtask'
require 'rdoc/task'
require File.dirname(__FILE__) + '/lib/spior/version'

# rake rdoc
Rake::RDocTask.new('rdoc') do |rdoc|
  rdoc.title = 'spior'
  rdoc.options << '--line-numbers'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include 'lib/**/*.rb', 'README.md'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList["test/test_*.rb"]
end

namespace :gem do
  desc 'build the gem'
  task :build do
    Dir["spior*.gem"].each {|f| File.unlink(f) }
    system('gem build spior.gemspec')
    system("gem install --user-install spior-#{Spior::VERSION}.gem -P MediumSecurity")
  end
end

task default: :test
