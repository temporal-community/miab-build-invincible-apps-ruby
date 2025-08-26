require 'temporalio/workflow'
require_relative 'activities'

module Counter
  class CountingWorkflow < Temporalio::Workflow::Definition
    def execute
      i = 1
      puts "***Counting to 10***"
      
      while i <= 10
        puts i.to_s
        
        i = Temporalio::Workflow.execute_activity(
          AddOneActivity,
          i,
          start_to_close_timeout: 3 # maximum time allowed for a single Activity Task Execution
        )
        
        Temporalio::Workflow.sleep(3)
      end
      
      Temporalio::Workflow.logger.info("***Finished counting to 10***")
    end
  end
end