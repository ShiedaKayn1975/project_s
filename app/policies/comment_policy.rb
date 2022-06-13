class CommentPolicy < BasePolicy
  def index?
    true
  end
  
  def create?
    true
  end
  
  def show?
    true
  end
  
  def update?
    user.admin
  end
  
  def destroy?
    user.admin
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end