require 'temporalio/workflow'
require 'temporalio/retry_policy' 

require_relative 'get_ip_activity'
require_relative 'get_location_activity'

module IPGeolocate
  class GetAddressFromIPWorkflow < Temporalio::Workflow::Definition
    def execute(name)
      ip = Temporalio::Workflow.execute_activity(
        GetIPActivity,
        start_to_close_timeout: 5,
      )
      
      location = Temporalio::Workflow.execute_activity(
        GetLocationActivity,
        ip,
        start_to_close_timeout: 5,
      )
      
      "Hello, #{name}. Your IP is #{ip} and you are located in #{location}."
    end
  end
end