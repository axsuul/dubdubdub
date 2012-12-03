# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dubdubdub"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Hu"]
  s.date = "2012-12-03"
  s.description = "A library that provides web utility methods with proxification."
  s.email = "axsuul@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "lib/dubdubdub.rb",
    "lib/dubdubdub/client.rb",
    "lib/dubdubdub/exceptions.rb",
    "spec/dubdubdub_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/vcr.rb",
    "spec/vcr/follow_url/alias_link.yml",
    "spec/vcr/follow_url/base.yml",
    "spec/vcr/follow_url/block_base_url.yml",
    "spec/vcr/follow_url/eoferror.yml",
    "spec/vcr/follow_url/https.yml",
    "spec/vcr/follow_url/pass_block.yml",
    "spec/vcr/follow_url/pass_block_iteration.yml",
    "spec/vcr/follow_url/proxied.yml",
    "spec/vcr/follow_url/proxy.yml",
    "spec/vcr/follow_url/proxy_forbidden.yml"
  ]
  s.homepage = "http://github.com/axsuul/dubdubdub"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Networking dubstep."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<vcr>, ["~> 2.3.0"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<vcr>, ["~> 2.3.0"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<vcr>, ["~> 2.3.0"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end

