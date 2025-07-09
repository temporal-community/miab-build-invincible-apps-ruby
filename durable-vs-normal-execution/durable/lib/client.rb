require_relative 'counter/workflow'
require 'temporalio/client'
require 'securerandom'

begin
  client = Temporalio::Client.connect('localhost:7233', 'default')
rescue StandardError => e
  puts e.message
  exit 1
end

# in practice, use a meaningful business ID, like customerId or transactionId
workflow_id = "counting-workflow-#{SecureRandom.hex(10)}"

# Run workflow
begin
  result = client.execute_workflow(
    Counter::CountingWorkflow,
    id: workflow_id,
    task_queue: 'durable'
  )
  
  puts "Started workflow #{workflow_id}"
  puts result
rescue StandardError => e
  puts "Error: #{e.message}"
  exit 1
end