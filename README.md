# jetty run 

* [![Build Status](https://secure.travis-ci.org/mkristian/jetty-run.png)](http://travis-ci.org/mkristian/jetty-run)
* [![Dependency Status](https://gemnasium.com/mkristian/jetty-run.png)](https://gemnasium.com/mkristian/jetty-run)
* [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mkristian/jetty-run)


## install ##

first uninstall older ruby-maven (< 3.0.4.0.29.0) if present, they will otherwise conflict with jetty-run command

    $ gem uninstall ruby-maven
	$ gem install jetty-run

## usage ##

    $ cd my_rails_app
 	$ jruby -S bundle install #optional
	$ jetty-run

or for a rack application (assuming existiing config.ru)

    $ cd my_rack_app
 	$ jruby -S bundle install #optional
	$ jetty-run

regarding `bundle install`: it must work wth JRuby since JRuby is the runtime environment. but `bundle install` since jetty-run will resolve a valid gemset itself and creates a Gemfile.lock (with the help of bundler). in short; all gems must be for the java platform or you need to provide jruby alternative gems.

`jetty-run` works with both MRI and JRuby - MRI starts up slightly faster BUT **uses JRuby** when running the applicaton.

jetty-run will use Gemfile/Gemfile.lock and Jarfile/Jarfile.lock to setup an environment to start rails in development mode with jetty. it uses ruby-maven to achieve this, i.e. all missing jar dependencies (jetty itself and all its dependences) will be downloaded on the first run (that can take time since it first needs to download all the jars).

jetty will start with port 8080 (none ssl) and 8443 (ssl). the ssl certificate is ./target/server.keystore with password '123456'.

to customize jetty you can use the _Mavenfile_ which allows to reconfigure jetty-maven-plugin, i.e. the version of jetty

    properties['jetty.version'] = '7.5.1.v20110908'

or you pass it in via the command line

	$ jetty-run -- -Djetty.version=7.5.1.v20110908
	
**--** is used a separator after which you can use any maven open available. like `-- -X` gives you a complete maven debug output, etc.

## running any given war-file ##

    jetty-run war /path/to/war-file

with this you can `warble` your warfile and use `jetty-run` to start it with jetty.

## more ##

see

    jetty-run help
	 
# note #

orginally the code was part the jruby-maven-plugins and slowly the functionality moved to the ruby side of things. so things are on the move and there is room for improvements . . .
    
contributing
------------

1. fork it
2. create your feature branch (`git checkout -b my-new-feature`)
3. commit your changes (`git commit -am 'Added some feature'`)
4. push to the branch (`git push origin my-new-feature`)
5. create new Pull Request

meta-fu
-------

bug-reports and pull request are most welcome. otherwise

enjoy :) 
