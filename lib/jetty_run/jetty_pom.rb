eval( File.read( java.lang.System.getProperty( "common.pom" ) ), nil, 
      java.lang.System.getProperty( "common.pom" ) )

plugin( '${jetty.group_id}:jetty-maven-plugin', '${jetty.version}',
        :path => '/',
        :war => '${jetty.war}',
        :webAppSourceDirectory => '${public.dir}',
        :webXml => '${webinf.dir}/web.xml',
        :daemon => '${run.fork}',
        :classesDirectory => '${lib.dir}',
        # that jetty 7 and 8
        :connectors => [ { :@implementation => "org.eclipse.jetty.server.nio.SelectChannelConnector",
                           :port => '${run.port}' },
                         { :@implementation => "org.eclipse.jetty.server.ssl.SslSelectChannelConnector",
                           :port => '${run.sslport}',
                           :keystore => '${run.keystore}',
                           :keyPassword => '${run.keystore.pass}',
                           :trustPassword => '${run.truststore.pass}' } ],
        # that is jetty 9
        :httpConnector => { :port => '${run.port}' },
        :jettyXml => '${jetty.xml}' )
