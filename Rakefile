require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "tabnav"
    gem.summary = %Q{Rails helper for generating navbars}
    gem.description = %Q{Rails helper for generating navbars in a declarative manner}
    gem.email = "github@unboxedconsulting.com"
    gem.homepage = "http://github.com/unboxed/tabnav"
    gem.authors = ["Unboxed"]
    gem.add_dependency "actionpack", ">= 2.3.8"
    gem.add_development_dependency "rspec", "~> 2.6.0"
    gem.add_development_dependency "rspec-rails", "~> 2.6.1"
    gem.files.exclude "*.gemspec", '.gitignore', 'doc/*'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tabnav #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
