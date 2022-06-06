# Every resource policy should extend this class
#
# For safe, restrict all access by default
#
# Idea: load resource record and attach to class instance
#
class BasePolicy < ApplicationPolicy  
  def index?
    false
  end

  def create?
    false
  end

  def show?
    false
  end

  def show_action_logs?
    show?
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
