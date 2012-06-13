#-*- mode: ruby -*-

# overwrite via cli -Djruby.versions=1.6.7
properties['jruby.versions'] = ['1.6.5.1','1.6.7.2','1.7.0.preview1'].join(',')
# overwrite via cli -Djruby.use18and19=false
properties['jruby.18and19'] = true

#plugin(:minitest) do |m|
#  m.execute_goal(:spec)
#end

plugin(:cucumber) do |m|
  m.execute_goal(:test)
end

# hack until test profile deps are normal deps with scope 'test'
profile(:test).activation.by_default

# vim: syntax=Ruby
