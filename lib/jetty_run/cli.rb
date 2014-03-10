#
# Copyright (C) 2014 Christian Meier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'thor'
require 'jetty_run/war'
require 'jetty_run/server'
require 'jetty_run/dump'
module JettyRun
  class Cli < Thor

    desc 'dump [Mavenfile]', 'dump Mavenfile or append the plugin config to an existing Mavenfile'
    method_option :mode, :type => :string, :enum => %w(create append append_plugin overwrite), :default => :create
    def dump( file = 'Mavenfile' )
      JettyRun::Dump.new( options ).dump( file )
    end

    desc 'war [WARFILE]', 'run a given war file'
    method_option :workdir, :type => :string, :desc => 'default: pkg'
    method_option :publicdir, :type => :string, :desc => 'default: public'
    method_option :mavenfile, :type => :string, :desc => 'the name has to starts with Mavenfile or has to have .rb extension. empty filename result in using a default file. default: Mavenfile'
    method_option :port, :type => :numeric
    method_option :sslport, :type => :numeric, :desc => 'ssl port. 0 means no ssl. the server cert is a self-signed cert for localhost (not 127.0.0.1 or ::1) and the browser might call it untrusted.'
    method_option :version, :type => :string, :desc => 'major jetty version, 7 or 6'
    method_option :verbose, :type => :boolean, :default => false
    method_option :debug, :type => :boolean, :default => false
    def war( file = nil )
      JettyRun::War.new( options ).run( file )
    end

    desc 'server', 'run application from filesystem'
    long_desc 'if there is no web.xml in filesystem a web.xml will be copied to public/WEB-INF for further customizations.'
    method_option :workdir, :type => :string, :desc => 'default: pkg'
    method_option :publicdir, :type => :string, :desc => 'default: public'
    method_option :mavenfile, :type => :string, :desc => 'the name has to starts with Mavenfile or has to have .rb extension. empty filename result in using a default file. default: Mavenfile'
    method_option :port, :type => :numeric
    method_option :sslport, :type => :numeric, :desc => 'ssl port. 0 means no ssl. the server cert is a self-signed cert for localhost (not 127.0.0.1 or ::1) and the browser might call it untrusted.'
    method_option :version, :type => :string, :desc => 'major jetty version, 7 or 6'
    method_option :clean, :type => :boolean, :default => false
    method_option :verbose, :type => :boolean, :default => false
    method_option :debug, :type => :boolean, :default => false
    def server
      JettyRun::Server.new( options ).run
    end

    desc 'default', 'will scand for warfile or just start the server', :hide => true
    method_option :workdir, :type => :string
    method_option :publicdir, :type => :string
    method_option :mavenfile, :type => :string
    method_option :port, :type => :numeric
    method_option :sslport, :type => :numeric
    method_option :version, :type => :string
    method_option :clean, :type => :boolean, :default => false
    method_option :verbose, :type => :boolean, :default => false
    method_option :debug, :type => :boolean, :default => false
    def default
      war = JettyRun::War.new( options )
      if file = war.warfile
        puts "found warfile #{file}"
        war.run( file )
      else
        puts 'run application from filesystem'
        server
      end
    end
  end
end
