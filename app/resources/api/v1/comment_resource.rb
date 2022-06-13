class Api::V1::CommentResource < Api::V1::BaseResource
  attributes :id, :content, :creator_id
end