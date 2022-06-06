class Api::V1::CategoryResource < Api::V1::BaseResource
  attributes :name, :code, :created_at, :updated_at

  filter :name, apply: ->(records, value, _options) {
    records.where("LOWER(name) LIKE ?", "%#{value[0].downcase}%")
  }
end
