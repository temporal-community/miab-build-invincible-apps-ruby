require 'temporalio/activity'
require 'net/http'
require 'uri'
require 'json'

module IPGeolocate
  class GetLocationActivity < Temporalio::Activity::Definition
    # Use the IP address to get the location
    def execute(ip)
      url = URI("http://ip-api.com/json/#{ip}")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      "#{data['city']}, #{data['regionName']}, #{data['country']}"
    end
  end
end