require 'temporalio/activity'

module Counter
  class AddOneActivity < Temporalio::Activity::Definition
    def execute(current_number)
      current_number + 1
    end
  end
end