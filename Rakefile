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

task :headers do
  require 'rubygems'
  require 'copyright_header'

  s = Gem::Specification.load( Dir["*gemspec"].first )

  args = {
    :license => s.license, 
    :copyright_software => s.name,
    :copyright_software_description => s.description,
    :copyright_holders => s.authors,
    :copyright_years => [Time.now.year],
    :add_path => 'lib',
    :output_dir => './'
  }

  command_line = CopyrightHeader::CommandLine.new( args )
  command_line.execute
end

# vim: syntax=Ruby
