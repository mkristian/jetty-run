require 'fileutils'
require 'maven/jetty/ruby_maven'

def rmvn
  @rmvn ||= begin
              rmvn = Maven::Jetty::RubyMaven.new
              # copy the jruby version and the ruby version (1.8 or 1.9)
              # to be used by maven process
              rmvn.options['-Djruby.version'] = JRUBY_VERSION if defined? JRUBY_VERSION
              
              rversion = RUBY_VERSION  =~ /^1.8./ ? '--1.8': '--1.9'
              rmvn.options['-Djruby.switches'] = rversion
              rmvn
            end
end

def copy(name, dir)
  path = File.join('it', name)
  base = File.join('target', dir)
  @target = File.join(base, name)
  FileUtils.rm_rf(@target)
  FileUtils.mkdir_p(base)
  FileUtils.cp_r(path, base)
end

Given /^application with Gemfile\.lock in "(.*)"$/ do |name|
  copy(name, 'with')
end

Then /^jetty runs$/ do
  rmvn.options['-l'] = 'output.log'
  #rmvn.options['-o'] = nil
  #rmvn.options['-X'] = nil
  #rmvn.options['-Djruby.verbose'] = true
  rmvn.options['-Dgem.home'] = ENV['GEM_HOME'] if ENV['GEM_HOME']
  rmvn.options['-Dgem.path'] = ENV['GEM_PATH'] if ENV['GEM_PATH']

  succeeded = rmvn.exec_in(@target, '-Prun,integration,assets')
  unless succeeded
    puts File.read('output.log')
    raise 'failure' 
  end
end

Given /^application without Gemfile\.lock in "(.*)"$/ do |name|
  copy(name, 'without')
  FileUtils.rm(File.join(@target, 'Gemfile.lock'))
end
