class Api::V1::ProductResource < Api::V1::BaseResource
  attributes :id, :title, :price, :compare_price, :commitions, :active, :created_at, :updated_at, :kind, :index

  before_save :add_creator
  before_save :add_active

  filter :kind, apply: ->(records, value, _options) {
    records.where("kind = ?", value[0])
  }
  # def creator_id
  #   if context[:user].admin?
  #     @model.creator_id
  #   else
  #     nil
  #   end
  # end

  private
  def add_creator
    if @model.new_record?
      unless @model.creator_id
        @model.creator_id = context[:user].id
      end
    end
  end

  def add_active
    if @model.new_record?
      @model.active = true
    end
  end
end
