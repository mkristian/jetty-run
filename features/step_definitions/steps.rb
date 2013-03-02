require 'fileutils'
require 'maven/jetty/cli'

def rmvn
  @rmvn ||= begin
              rmvn = Maven::Jetty::Cli.new
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
  #rmvn.options['-o'] = nil # maven offline
  #rmvn.options['-X'] = nil # maven debug
  #rmvn.options['-Dverbose'] = true # ruby-maven debug
  #rmvn.options['-Djruby.verbose'] = true # jruby-maven-plugins debug
  rmvn.options['-Dgem.home'] = ENV['GEM_HOME'] if ENV['GEM_HOME']
  rmvn.options['-Dgem.path'] = ENV['GEM_PATH'] if ENV['GEM_PATH']
  gemfile = File.expand_path( File.join( @target, 'Gemfile' ) )
  rmvn.options['-Dbundler.args'] = "--gemfile=#{gemfile}" if File.exists? gemfile

  if defined? JRUBY_VERSION
    java.lang.System.setProperty( 'user.dir', File.expand_path( @target ) )
  end
  puts `cd #{@target}`
  succeeded = rmvn.exec_in(@target, '-Prun,integration,assets')
  unless succeeded
    puts File.read(File.join(@target, rmvn.options['-l'] ) )
    raise 'failure' 
  end
end

Given /^application without Gemfile\.lock in "(.*)"$/ do |name|
  copy(name, 'without')
  FileUtils.rm(File.join(@target, 'Gemfile.lock'))
end
