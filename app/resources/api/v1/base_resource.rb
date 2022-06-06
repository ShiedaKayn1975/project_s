class Api::V1::BaseResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource
  include Actionable::JSONAPIResource

  abstract

  def self.default_sort
    [
      { field: :updated_at, direction: :desc }
    ]
  end

  filters :id

  filter :ids, apply: ->(records, value, _options) {
    records.where(records.count > 0 ? "#{records.first.class.table_name}.id IN (?)" : "id IN (?)", value)
  }
end