class Api::V1::ActionsController < Api::V1::ApiController
  before_action :get_object

  def create
    action_code = params[:action_code]&.to_sym
    action = @object_class::Actions[action_code]

    return render_error "Cannot execute this action" unless action

    action_log = action.commit!(@object, get_context)
    if action_log.state == ActionLog::State::Finished
      return render json: action_log.as_json
    else
      return render json: action_log.as_json, status: 400
    end
  end

  private 

  OBJECT_NAME_REGEX = Regexp.new(
    '/([^/]+)/[^/]+/actions'
  )

  def get_object
    @object_name = request.url.match(OBJECT_NAME_REGEX)[1]
    @object_class = @object_name.classify.constantize
    object_id_key = "#{@object_name.singularize}_id"
    object_id     = params[object_id_key]

    @object = @object_class.find(object_id)
  end

  def get_context
    context = Actionable::Context.new(
      actor: current_user,
      data: params[:action_data]
    )

    context
  end
end
