# Load Bundler and load all your gems
require_relative "ip_geolocate/get_ip_activity"
require_relative "ip_geolocate/get_location_activity"
require_relative "ip_geolocate/get_address_from_ip_workflow"

module IPGeolocate
  TASK_QUEUE_NAME = "ip-address-ruby"
end