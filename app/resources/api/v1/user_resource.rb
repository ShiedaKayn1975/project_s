class Api::V1::UserResource < Api::V1::BaseResource
  attributes :id, :name, :phone, :status, :created_at, :updated_at, :balance

  def balance
    return nil unless context[:user].admin?
    @model.balance
  end
end