require 'rubygems'
require 'cgi'
require 'net/https'
require 'net/http'
require 'xmlsimple'
require 'JSON'

userId = "omid.sojoodi"
albumId = "20130524London"
access = "private"
authkey= "Gv1sRgCPrO383_68fahQE"
main_url = "https://picasaweb.google.com/data/feed/api/user/#{userId}/album/#{albumId}?&kind=photo&access=private&authkey=#{authkey}&full-exif=true&max-results=500&alt=json"
      
url = URI.parse(URI.encode(main_url))
response = Net::HTTP.start(url.host, use_ssl: true, verify_mode: 
OpenSSL::SSL::VERIFY_NONE) do |http|
     http.get url.request_uri
end

case response
  when Net::HTTPRedirection
    a= 1
  when Net::HTTPSuccess
    outputData = JSON.parse response.body
    a=2
  else
  # response code isn't a 200; raise an exception
    pp response.error!
end
