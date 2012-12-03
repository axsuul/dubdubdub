# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/dubdubdub'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dubdubdub"
  gem.homepage = "http://github.com/axsuul/dubdubdub"
  gem.license = "MIT"
  gem.summary = %Q{Networking dubstep.}
  gem.description = %Q{A library that provides web utility methods with proxification.}
  gem.email = "axsuul@gmail.com"
  gem.authors = ["James Hu"]
  gem.version = DubDubDub::VERSION
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec