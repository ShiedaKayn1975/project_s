class ActionLog < ApplicationRecord
    belongs_to :actor, class_name: 'User'
    belongs_to :actionable, polymorphic: true
    
    module State
      Created = 'created'
      Aborted = 'aborted'
      Finished = 'finished'
      Failed = 'failed'
    end
  end
  