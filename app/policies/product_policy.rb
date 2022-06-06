class ProductPolicy < BasePolicy
  def index?
    true
  end

  def create?
    user.admin
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
      if user.admin?
        scope.all
      else        
        scope.where(active: true)
      end
    end
  end
end