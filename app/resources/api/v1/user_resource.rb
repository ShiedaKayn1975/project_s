class Api::V1::UserResource < Api::V1::BaseResource
    attributes :id, :name, :phone, :status, :admin, :created_at, :updated_at, :balance
end