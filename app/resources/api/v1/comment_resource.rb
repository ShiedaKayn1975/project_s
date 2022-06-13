class Api::V1::CommentResource < Api::V1::BaseResource
  attributes :id, :content, :creator_id, :created_at
end