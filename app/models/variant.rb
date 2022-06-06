class Variant < ApplicationRecord
  belongs_to :product
  
  module Status
    ACTIVE = 'active'
    DISABLED = 'disabled'
    SELLED = 'selled'
  end
end
