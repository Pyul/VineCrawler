require 'net/https'
require 'uri'

class VineCrawler
    def getJSON(searchTerm)
	    
	end
	
	def parseURLs(jsonBody)
	
	end
end

url = URI.parse('https://vine.co/api/posts/search/super%20bowl?size=10')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

req = Net::HTTP::Get.new(url.request_uri)
res = http.request(req)

resultBody = res.body
testStr = "\"videoWebmUrl\": null, \"vanityUrls\": [\"UsTheDuo\"], \"tags\": [], \"permalinkUrl\": \"https://vine.co/v/MzxYHUd0BZv\", \"following\": 0, \"postId\": 1041850030673514496, \"videoUrl\": \"http://v.cdn.vine.co/r/videos/5CDC5B355B1041849921499713536_178382acdd8.4.7.13252749354937395027_kKPmeDCRONXMx4LgvW7ECIHoXSe3MWEbYonaduayd.f2bNVuZmV2xLGA6wJJCSB1.mp4?versionId=Sm5V4Ryio8nt8OaSBmlW53cmrePOChJR\", \"followRequested\": 0, \"created\": \"2014-02-\""

videoRegexMatches = resultBody.scan(/\"videoUrl\": \"[^\"]*\"/)
videoUrls = []

videoRegexMatches.each do | match |
    videoUrls << match.split('"')[3]
end

numVideo = 1

videoUrls.each do | nextUrl |
	# nextUrl = nextUrl.split('.mp4')[0] + ".mp4"
    nextURI = URI.parse(nextUrl);
	http = Net::HTTP.new(nextURI.host, nextURI.port)
	
	req = Net::HTTP::Get.new(nextURI.request_uri)
    req["Content-Type"] = "video/mp4"
	
	res = http.request(req)
	
	open("#{numVideo}.mp4", "wb") do | file |
		file << res.body
	end
	
	numVideo = numVideo + 1
end
