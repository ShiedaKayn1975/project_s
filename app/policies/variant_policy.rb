class VariantPolicy < BasePolicy
  def index?
    true
  end

  def create?
    user.admin
  end

  def show?
    user.admin
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
          scope.where(owner: user.id)
      end
    end
  end
end