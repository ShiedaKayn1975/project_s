class Action
  attr_accessor :code, :label

  attr_accessor :hdl_show
  attr_accessor :hdl_authorized
  attr_accessor :hdl_commitable
  attr_accessor :hdl_commit

  # def initialize
  #   @attribute = attribute
  # end

  def commit! object, context
    execute object, context
  end

  def commitable? object, context
    !hdl_commitable || instance_exec(object, context, &hdl_commitable)
  end

  def show? object, context
    !hdl_show || instance_exec(object, context, &hdl_show)
  end

  def authorized? object, context
    !hdl_authorized || instance_exec(object, context, &hdl_authorized)  
  end

  private

  def commit object, context
    instance_exec(object, context, &hdl_commit)
  end

  def execute object, context
    verify_context context

    log = initialize_action_log object, context

    if !(commitable = authorized?(object, context))
      log.state = ActionLog::State::Aborted
      log.error = { message: 'Unauthorized'}
    elsif !(commitable_ = (commitable && commitable?(object, context)))
      log.state = ActionLog::State::Aborted
      log.error = { message: 'Wrong context'}
    end

    if commitable_
      begin
        commit object, context
        log.state = ActionLog::State::Finished
      rescue Actionable::InvalidDataError => ex
        log.state = ActionLog::State::Aborted
        log.error = { message: ex.message }
      end
    end
    log.save!
    log
  end

  def initialize_action_log object, context
    ActionLog.create!(
      state: ActionLog::State::Created,
      actor_id: context.actor.id,
      actionable: object,
      action_code: self.code,
      action_label: self.label,
      action_data: context.data || {},
      context: {},
    )
  end

  def verify_context context
    unless context.actor
      raise Actionable::ActorMissingError.new("Actor is required to commit action")
    end
  end
end