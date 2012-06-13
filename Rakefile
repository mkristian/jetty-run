#-*- mode: ruby -*-

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'fileutils'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => [:features]#[ :clean, :features, :minispec]

# task :minispec => [:compile] do
#   require 'bundler/setup'
#   require 'minitest/autorun'

#   $LOAD_PATH << "spec"

#   Dir['spec/*_spec.rb'].each { |f| require File.basename(f.sub(/.rb$/, '')) }
# end

task :clean do
  FileUtils.rm_rf('target')
end

# vim: syntax=Ruby
