# -*- coding: utf-8 -*-
require File.expand_path('lib/maven/jetty/version.rb')
Gem::Specification.new do |s|
  s.name = 'jetty-run'
  s.version = Maven::Jetty::VERSION.dup

  s.summary = 'run rails with jetty'
  s.description = 'installs and run jetty from within a rails directory with ssl and none ssl port'

  s.homepage = 'http://github.com/mkristian/jetty-run'

  s.authors = ['Kristian Meier']
  s.email = ['m.kristian@web.de']

  s.bindir = "bin"
  s.executables = ['jetty-run']

  s.files += Dir['bin/*']
  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*']
  s.files += Dir['MIT-LICENSE'] + Dir['*.md']
  s.test_files += Dir['spec/**/*_spec.rb']
  s.add_development_dependency 'rake', '0.9.2.2'
  s.add_runtime_dependency 'ruby-maven', '3.0.4.0.29.0'
end
