class Api::V1::TicketResource < Api::V1::BaseResource
  attributes :id, :content, :code, :status, :creator_id, :created_at, :updated_at

	before_save :add_creator_and_status

	private
	def add_creator_and_status
    if @model.new_record?
      unless @model.creator_id
        @model.creator_id = context[:user].id
      end

			unless @model.status
				@model.status = 'open'
			end
    end
  end
end