class VariantGateway
  def import_variants file, context, args={}
    import_log = args[:import_log]
    product_id = args[:product_id]

    content = IO.read(file.tempfile)
    content.encode!('UTF-8', :invalid => :replace, :undef => :replace)
    
    data = content.split("\n").map do |item|
      [item.split("|", 2).first, item]
    end.to_h

    account_uids = data.keys.uniq

    # unique value
    data = account_uids.map do |uid|
      [uid, data[uid]]
    end.to_h

    existing_items = Variant.where(account_uid: account_uids).map do |item|
      item.account_uid
    end

    if !existing_items.blank?
      existing_items.each do |item|
        data.delete(item)
      end
    end

    variants = data.map{|item|
      variant = Variant.new
      variant.import_log_id = import_log.id if import_log
      variant.product_id = product_id
      variant.info = item.second
      variant.account_uid = item.first
      variant.status = Variant::Status::ACTIVE

      variant
    }

    response = data

    begin
      result = Variant.import(variants)
    rescue StandardError => ex
      response = {}
    end

    { 
      data: response
    }
  end
end