# jetty run [![Build Status](https://secure.travis-ci.org/mkristian/jetty-run.png)](http://travis-ci.org/mkristian/jetty-run) #

## install ##

first uninstall older ruby-maven (< 3.0.4.0.29.0) if present, they will otherwise conflict with jetty-run command

    $ gem uninstall ruby-maven
	$ gem install jetty-run

## usage ##

    $ cd my_rails_app
 	$ jruby -S bundle install
	$ jetty-run

for `bundle install` you need to use JRuby since Gemfile.lock needs to be for the java platform. `jetty-run` works with both MRS and JRUBY - MRI starts up slightly faster.

jetty-run will use Gemfile/Gemfile.lock and Jarfile/Jarfile.lock to setup an environment to start rails in development mode with jetty. it uses ruby-maven to achieve this, i.e. all missing jar dependencies (jetty and all) will be downloaded on the first run (that can take time since it first needs to download all the jetty related jars).

jetty will start with port 8080 (none ssl) and 8443 (ssl). the ssl certificate is ./src/test/resources/server.keystore with password '123456' - it will be copied there on the first run.

to customize jetty you can use the _Mavenfile_ which allows to reconfigure jetty-maven-plugin:

    properties['jetty.version'] = '7.5.1.v20110908'

TODO more advanced example and current config

## running any given war-file ##

    jetty-run war /path/to/war-file

with this you warble your warfile and use jetty-run to start it with jetty.

## more ##

see

    jetty-run help
	 
# note #

orginally the code was part the jruby-maven-plugins and slowly the functionality moved to the ruby side of things. so things are on the move and there is room for improvements . . .

# meta-fu #

bug-reports and pull request are most welcome.

