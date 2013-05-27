# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dubdubdub"
  s.version = "0.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Hu"]
  s.date = "2013-05-27"
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
    "dubdubdub.gemspec",
    "lib/dubdubdub.rb",
    "lib/dubdubdub/client.rb",
    "lib/dubdubdub/configuration.rb",
    "lib/dubdubdub/exceptions.rb",
    "spec/dubdubdub_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/vcr.rb",
    "spec/vcr/browse/basic.yml",
    "spec/vcr/crawl/basic.yml",
    "spec/vcr/follow/alias_link.yml",
    "spec/vcr/follow/all_the_way.yml",
    "spec/vcr/follow/bad_request.yml",
    "spec/vcr/follow/base.yml",
    "spec/vcr/follow/eoferror.yml",
    "spec/vcr/follow/https.yml",
    "spec/vcr/follow/invalid_uris.yml",
    "spec/vcr/follow/pass_block.yml",
    "spec/vcr/follow/pass_block_iteration.yml",
    "spec/vcr/follow/proxy.yml",
    "spec/vcr/follow/proxy_forbidden.yml",
    "spec/vcr/follow/relative_redirects.yml",
    "spec/vcr/follow/uri_error.yml",
    "spec/vcr/get/basic.yml",
    "spec/vcr/get/doesnt_exist.yml",
    "spec/vcr/get/infinite_redirects.yml",
    "spec/vcr/get/params.yml",
    "spec/vcr/get/proxy.yml"
  ]
  s.homepage = "http://github.com/axsuul/dubdubdub"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Networking dubstep."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<mechanize>, ["= 2.7.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<vcr>, ["~> 2.4.0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<mechanize>, ["= 2.7.0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<vcr>, ["~> 2.4.0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<mechanize>, ["= 2.7.0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<vcr>, ["~> 2.4.0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end

