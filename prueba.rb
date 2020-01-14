require "uri"
require "net/http"
require "json"
require_relative "helpers"

def request(url)
    url = URI(url)
    
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)
    
    response = https.request(request)
    JSON.parse(response.read_body)
end

def build_web_page
    data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=Ejl2s0gGWR5laGk53Gf0iGLGft5LPbdGFPVk0gzX') 
    clean_data = data['photos']
    File.open('rovers.html', 'w') do |f|
        f.puts head
        clean_data.each do |photo|
            f.puts "<li><img src='#{photo['img_src']}'></li>"
        end
        f.puts footer
    end
end

build_web_page

def photo_count
    data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=Ejl2s0gGWR5laGk53Gf0iGLGft5LPbdGFPVk0gzX')
    clean_data = data['photos']
    count = {}

    clean_data.map do |k|
        if count[k['camera']['name']]
            count [k['camera']['name']] = count [k['camera']['name']] + 1
        else
            count [k['camera']['name']] = 1
        end
    end

 puts count
end

photo_count


