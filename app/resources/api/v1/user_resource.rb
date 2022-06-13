class Api::V1::UserResource < Api::V1::BaseResource
  attributes :id, :name, :phone, :status, :created_at, :updated_at, :balance

  def balance
    return nil unless context[:user].admin?
    @model.balance
  end

  def phone
    return nil unless context[:user].admin?
    @model.phone
  end
end