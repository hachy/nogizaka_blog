# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nogizaka_blog/version'

Gem::Specification.new do |spec|
  spec.name          = 'nogizaka_blog'
  spec.version       = NogizakaBlog::VERSION
  spec.authors       = ['hachy']
  spec.email         = ['1613863+hachy@users.noreply.github.com']
  spec.summary       = %(Get the number of comments and articles per month from Nogizaka46's blog)
  spec.description   = %(Get the number of comments and articles per month from Nogizaka46's blog)
  spec.homepage      = 'https://github.com/hachy/nogizaka_blog'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'thor'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
