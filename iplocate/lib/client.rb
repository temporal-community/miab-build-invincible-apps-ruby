require_relative 'ip_geolocate'
require 'temporalio/client'

name = ARGV[0]
unless name
  puts "Please provide your name when running the program."
  exit 1
end

# Create a client
begin
  client = Temporalio::Client.connect('localhost:7233', 'default')
rescue StandardError => e
  puts e.message
  exit 1
end

# Run workflow
result = client.execute_workflow(
  IPGeolocate::GetAddressFromIPWorkflow,
  name, # This is the input to the workflow
  id: 'my-workflow-id',
  task_queue: IPGeolocate::TASK_QUEUE_NAME,
)

puts result