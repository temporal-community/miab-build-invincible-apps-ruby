require_relative 'ip_geolocate'
require 'temporalio/client'
require 'temporalio/worker'

# Create a client
begin
  client = Temporalio::Client.connect('localhost:7233', 'default')
rescue StandardError => e
  puts e.message
  exit 1
end

# Create a worker with the client, activities, and workflows
worker = Temporalio::Worker.new(
  client:,
  task_queue: IPGeolocate::TASK_QUEUE_NAME,
  workflows: [IPGeolocate::GetAddressFromIPWorkflow],
  activities: [IPGeolocate::GetIPActivity, IPGeolocate::GetLocationActivity]
)

# Run the worker until SIGINT. This can be done in many ways, see "Workers" section for details.
worker.run(shutdown_signals: ['SIGINT'])