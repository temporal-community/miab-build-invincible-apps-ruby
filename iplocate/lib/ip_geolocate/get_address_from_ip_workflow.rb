require 'temporalio/workflow'
require 'temporalio/retry_policy' 

require_relative 'get_ip_activity'
require_relative 'get_location_activity'

module IPGeolocate
  class GetAddressFromIPWorkflow < Temporalio::Workflow::Definition
    def execute(name)
      ip = Temporalio::Workflow.execute_activity(
        GetIPActivity,
        start_to_close_timeout: 300,
        retry_policy: Temporalio::RetryPolicy.new(
          initial_interval: 2.0,      # amount of time that must elapse before the first retry occurs
          backoff_coefficient: 1.5,   # Coefficient used to calculate the next retry interval
          max_interval: 30.0          # maximum interval between retries
          # max_attempts: 5,          # Uncomment this if you want to limit attempts
          # non_retryable_error_types: # Defines non-retryable error types
        )
      )
      
      location = Temporalio::Workflow.execute_activity(
        GetLocationActivity,
        ip,
        schedule_to_close_timeout: 300
      )
      
      "Hello, #{name}. Your IP is #{ip} and you are located in #{location}."
    end
  end
end