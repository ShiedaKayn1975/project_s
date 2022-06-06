class TransactionPolicy < BasePolicy
    def index?
      true
    end
  
    def create?
      false
    end
  
    def show?
      true
    end
  
    def update?
      false
    end
  
    def destroy?
      false
    end
  
    class Scope < Scope
      def resolve
        if user.admin?
            scope.all
        else        
            scope.where(user_id: user.id)
        end
      end
    end
  end