require_relative 'counter/workflow'
require_relative 'counter/activities'
require 'temporalio/client'
require 'temporalio/worker'

begin
  client = Temporalio::Client.connect('localhost:7233', 'default')
rescue StandardError => e
  puts e.message
  exit 1
end

worker = Temporalio::Worker.new(
  client:,
  task_queue: 'durable',
  workflows: [Counter::CountingWorkflow],
  activities: [Counter::AddOneActivity]
)

worker.run(shutdown_signals: ['SIGINT'])