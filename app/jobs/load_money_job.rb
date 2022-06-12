class LoadMoneyJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 0

  def perform    
    response = TransactionService.get_transactions

    if response["status"] == true
      transactions = response["data"]["ChiTietGiaoDich"]
      references = transactions.map{|i| i['SoThamChieu']}

      all_transactions = Transaction.where(reference: references).map{|trans| trans.reference}
      data = []
      logs = []

      transactions.each do |transaction|
        reference = transaction['SoThamChieu']
        unless all_transactions.include? reference
          new_item = {}
          new_log  = {}

          message = transaction['MoTa']
          user_id = message.split('.').last.downcase.gsub(/[nokia]/, '').to_i
          money = transaction['SoTienGhiCo'].gsub(/[,]/, '').to_i
          if money > 19999
            method = transaction['CD']
          
            new_item["user_id"] = user_id
            new_item["reference"] = reference
            new_item["message"] = message
            new_item["amount"] = money
            new_item["method"] = method

            user = User.find_by(id: user_id)
            if user_id && user
              new_balance = (user.balance || 0) + money
              user.balance = new_balance
              user.save

              new_log['state'] = 'finished'
              new_log['action_code'] = 'load_money'
              new_log['action_label'] = 'Load Money'
              new_log['action_data'] = { 'amount': money }
              new_log['context'] = {}
              new_log['actor_id'] = user.id
              new_log['actionable_type'] = 'User'
              new_log['actionable_id'] = user.id

              logs << new_log
              data << new_item
            end
          end
        end
      end

      result = Transaction.import(data) unless data.blank?
      ActionLog.import(logs) unless logs.blank?      
    end
  end
end
