require 'temporalio/workflow'
require 'temporalio/retry_policy' 

require_relative 'get_ip_activity'
require_relative 'get_location_activity'

module IPGeolocate
  class GetAddressFromIPWorkflow < Temporalio::Workflow::Definition
    def execute(name, sleep_duration = nil)
      if sleep_duration && sleep_duration > 0
        Temporalio::Workflow.sleep(sleep_duration)
      end

      ip = Temporalio::Workflow.execute_activity(
        GetIPActivity,
        start_to_close_timeout: 5,
      )
      
      location = Temporalio::Workflow.execute_activity(
        GetLocationActivity,
        ip,
        start_to_close_timeout: 5,
      )
      
      sleep_message = sleep_duration && sleep_duration > 0 ? 
        " (waited #{sleep_duration} seconds)" : ""
      
      "Hello, #{name}. Your IP is #{ip} and you are located in #{location}.#{sleep_message}"
    end
  end
end