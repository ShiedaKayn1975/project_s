class ApplicationPolicy
  attr_reader :user, :record, :context

  def initialize(user, record)
    if user.respond_to?('[]') && user[:user]
      @context = user
      @user = @context[:user]
    else
      @context = nil
      @user = user
    end

    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end
  
  def update?
    false
  end  

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(context, record.class)
  end

  class Scope
    attr_reader :user, :scope, :context

    def initialize(user, scope)
      if user.respond_to?('[]') && user[:user]
        @context = user
        @user = @context[:user]
      else
        @context = nil
        @user = user
      end

      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
