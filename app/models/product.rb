class Product < ApplicationRecord
  include Actionable
  has_many :variants

  action :update_active do
    label "Update active"

    show? do |object, context|
      false
    end

    authorized? do |object, context|
      context[:actor].admin?
    end

    commitable? do |object, context|
      true
    end
    
    commit do |object, context|
      object.active = context[:data]["active"]
      object.save
    end
  end

  action :buy do
    label "Buy"

    show? do |object, context|
      false
    end

    authorized? do |object, context|
      true
    end

    commitable? do |object, context|
      object.active?
    end
    
    commit do |object, context|
      amount = context[:data]["amount"].to_i
      
      raise Actionable::InvalidDataError.new("Bạn chưa nhập số lượng") unless amount > 0

      variants = Variant.where(product_id: object.id, status: 'active').limit(amount)
      raise Actionable::InvalidDataError.new("Sản phẩm đã hết hàng") if variants.blank?

      price = object.price
      total = variants.count*price
      balance = context[:actor].balance || 0

      if total <= balance
        remaining_balance = balance - total
        context[:actor].balance = remaining_balance
        context[:actor].save

        variants.update_all(owner: context[:actor].id, status: 'buyed', buyed_at: Time.now)
      else
        raise Actionable::InvalidDataError.new("Tài khoản của bạn không đủ tiền")
      end
    end
  end
end
