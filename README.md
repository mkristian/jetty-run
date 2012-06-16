# jetty run [![Build Status](https://secure.travis-ci.org/mkristian/jetty-run.png)](http://travis-ci.org/mkristian/jetty-run) #
#

jetty-run will use Gemfile/Gemfile.lock and Jarfile/Jarfile.lock to setup an environment to start rails in development mode with jetty. it uses ruby-maven to achieve this, i.e. all missing jar dependencies (jetty and all) will be downloaded on the first run (that can take time since it is a lot).

jetty will start with port 8080 (none ssl) and 8443 (ssl). the ssl certificate is ./src/test/resources/server.keystore with password '123456' - it will be copied there on the first run.

to customize jetty you can use _Mavenfile_ which allows to reconfigure jetty-maven-plugin with a ruby DSL:

     properties['jetty.version'] = '7.5.1.v20110908'

TODO more advanced example and current config

# note #

most functionality is hidden inside 'maven-tools' gem and de.saumya.mojo:ruby-tools jar (from jruby-maven-plugins). it was first part of these jruby-maven-plugins and slowly the functionality moved to the ruby side of things. so things are on the move . . .
