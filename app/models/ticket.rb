class Ticket < ApplicationRecord
  has_many :comments, foreign_key: 'object_id', class_name: 'Comment'
  has_one :creator, :class_name => 'User', :foreign_key => 'id', :primary_key => 'creator_id'

  after_create :generate_code
  include Actionable

  action :comment do
    label "Comment"

    show? do |object, context|
      false
    end

    authorized? do |object, context|
      context[:actor].admin? || (context[:actor].id == object.creator_id)
    end

    commitable? do |object, context|
      true
    end
    
    commit do |object, context|
      comment = Comment.new
      comment.creator_id = context[:actor].id
      comment.content = context[:data]['content']
      comment.object_type = 'tickets'
      comment.object_id = object.id

      comment.save
    end
  end

  private
  def generate_code
    self.code = 'TK' + self.id.to_s
    self.save
  end
end
