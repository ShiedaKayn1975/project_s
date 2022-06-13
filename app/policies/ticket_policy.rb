class TicketPolicy < BasePolicy
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
      if user.admin?
        scope.all
      else
        scope.where(creator_id: user.id)
      end
    end
  end
end