class Comment < ApplicationRecord
  belongs_to :tickets, class_name: 'Ticket', foreign_key: :object_id
end
