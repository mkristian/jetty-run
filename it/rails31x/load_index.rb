require 'net/http'
result = Net::HTTP.get(URI.parse('http://localhost:8080'))
#puts result
raise 'wrong content' unless result =~ /Ruby on Rails: Welcome aboard/
