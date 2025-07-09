require 'json'
require 'net/http'
require 'uri'
require 'temporalio/activity'

module IPGeolocate
  class GetIPActivity < Temporalio::Activity::Definition
    def execute
      url = URI('https://icanhazip.com')
      
      # Create an HTTP session that can be reused
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      
      # Start a session
      http.start do |session|
        # Make the request within the session
        request = Net::HTTP::Get.new(url.request_uri)
        response = session.request(request)
        
        # Return the response body with whitespace removed
        response.body.strip
      end
    end
  end
end