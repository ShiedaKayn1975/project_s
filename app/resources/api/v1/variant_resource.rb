class Api::V1::VariantResource < Api::V1::BaseResource
  attributes :id, :product_id, :info, :account_uid, :status, :created_at, :updated_at, :owner, :buyed_at

  has_one :product

  filter :search, apply: ->(records, value, _options) {
    records.where("LOWER(account_uid) LIKE ?", "%#{value[0].downcase}%")
  }

  filter :product_ids, apply: ->(records, value, _options) {
    records.where(product_id: value[0])
  }

  filter :status, apply: ->(records, value, _options) {
    records.where(status: value[0])
  }
end
