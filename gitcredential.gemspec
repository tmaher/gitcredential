require 'find'

Gem::Specification.new do |s|
  s.name = 'gitcredential'
  s.version = File.read("VERSION").chomp
  s.summary = 'Ruby Wrapper for `git credential`'
  s.description = "Shells out to git-credential's various backends for secure credential management"
  s.authors = ["Tom Maher"]
  s.email = "tmaher@pw0n.me"
  s.license = "MIT"
  s.files = `git ls-files`.split("\n")
  s.homepage = "https://github.com/tmaher/gitcredential"
  s.add_development_dependency "woof_util", "~> 0.0.18"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
